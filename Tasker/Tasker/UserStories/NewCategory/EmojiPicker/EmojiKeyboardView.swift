//
//  EmojiKeyboardView.swift
//  Tasker
//
//  Created by Roman Apanasevich on 15.06.2025.
//

import UIKit

class EmojiKeyboardView: UIView {
	typealias Section = EmojiCategory
	
	struct EmojiItem: Hashable {
		let section: Section
		let index: Int
		let emoji: String
	}
	
	private let insertText: (String) -> Void
	private let keyboardHeight: CGFloat
	
	private let columns = 6
	private let horizontalSpacing: CGFloat = 8
	private let verticalSpacing: CGFloat = 8
	private let verticalPadding: CGFloat = 8
	private let horizontalPadding: CGFloat = 24
	private let categoryBarHeight: CGFloat = 30
	
	private var selectedCategory: EmojiCategory = .smileys {
		didSet {
			updateCategorySelection()
		}
	}
	
	private lazy var collectionView: UICollectionView = {
		let cv = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
		cv.backgroundColor = .clear
		cv.showsHorizontalScrollIndicator = false
		cv.showsVerticalScrollIndicator = false
		cv.alwaysBounceVertical = false
		cv.alwaysBounceHorizontal = false
		cv.decelerationRate = .fast
		cv.delegate = self
		cv.translatesAutoresizingMaskIntoConstraints = false
		return cv
	}()
	
	private var dataSource: UICollectionViewDiffableDataSource<Section, EmojiItem>!
	
	private lazy var categoryBar: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.distribution = .equalSpacing
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	
	private var categoryButtons: [UIButton] = []
	
	init(insertText: @escaping (String) -> Void, keyboardHeight: CGFloat) {
		self.insertText = insertText
		self.keyboardHeight = keyboardHeight
		super.init(frame: .zero)
		setupUI()
		self.layer.cornerRadius = 12
		self.clipsToBounds = true
		setupCategoryBar()
		setupCollectionView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		addSubview(categoryBar)
		addSubview(collectionView)
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: categoryBar.topAnchor, constant: -verticalPadding),
			
			categoryBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -4),
			categoryBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
			categoryBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
			categoryBar.heightAnchor.constraint(equalToConstant: categoryBarHeight),
		])
	}
	
	private func setupCategoryBar() {
		for category in EmojiCategory.allCases {
			let button = UIButton(type: .system)
			button.setImage(category.image, for: .normal)
			button.tag = category.rawValue
			button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
			button.widthAnchor.constraint(equalToConstant: 30).isActive = true
			button.heightAnchor.constraint(equalToConstant: 30).isActive = true
			button.layer.cornerRadius = categoryBarHeight / 2
			button.clipsToBounds = true
			button.backgroundColor = .clear
			categoryBar.addArrangedSubview(button)
			categoryButtons.append(button)
		}
		updateCategorySelection()
	}
	
	private func updateCategorySelection() {
		for (index, button) in categoryButtons.enumerated() {
			if index == selectedCategory.rawValue {
				button.tintColor = .label
				button.backgroundColor = .tertiarySystemFill
			} else {
				button.tintColor = .secondaryLabel
				button.backgroundColor = .clear
			}
		}
	}
	
	private func makeLayout() -> UICollectionViewCompositionalLayout {
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.scrollDirection = .horizontal
		config.interSectionSpacing = 0

		let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, env in
			let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(32), heightDimension: .absolute(32))
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			
			let columnSize = NSCollectionLayoutSize(widthDimension: .absolute(32), heightDimension: .fractionalHeight(1.0))
			let column = NSCollectionLayoutGroup.vertical(layoutSize: columnSize, repeatingSubitem: item, count: 5)
			column.interItemSpacing = .fixed(8)
			
			let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(10), heightDimension: .absolute(32*5 + 8*4))
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [column])
			
			let section = NSCollectionLayoutSection(group: group)
			section.interGroupSpacing = 16
			let isLast = sectionIndex == EmojiCategory.allCases.count - 1
			section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 11, trailing: isLast ? 24 : 0)
			return section
		}, configuration: config)

		return layout
	}
	
	private func setupCollectionView() {
		let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, EmojiItem> { cell, indexPath, item in
			let tag = 999
			let lbl: UILabel
			if let existing = cell.contentView.viewWithTag(tag) as? UILabel {
				lbl = existing
			} else {
				lbl = UILabel()
				lbl.tag = tag
				lbl.translatesAutoresizingMaskIntoConstraints = false
				lbl.textAlignment = .center
				cell.contentView.addSubview(lbl)
				NSLayoutConstraint.activate([
					lbl.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
					lbl.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
				])
			}
			lbl.text = item.emoji
			lbl.font = .systemFont(ofSize: 28)
		}

		dataSource = UICollectionViewDiffableDataSource<Section, EmojiItem>(collectionView: collectionView) { collectionView, indexPath, item in
			collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
		}
		
		var snap = NSDiffableDataSourceSnapshot<Section, EmojiItem>()
		for section in EmojiCategory.allCases {
			snap.appendSections([section])
			let emojis = section.emojis
			let items: [EmojiItem] = emojis.enumerated().map { EmojiItem(section: section, index: $0.offset, emoji: $0.element) }
			snap.appendItems(items, toSection: section)
		}
		dataSource.apply(snap, animatingDifferences: false)
	}
	
	@objc private func categoryTapped(_ sender: UIButton) {
		guard let category = EmojiCategory(rawValue: sender.tag) else { return }
		let section = category.rawValue
		
		if dataSource.snapshot().sectionIdentifiers.indices.contains(section) {
			collectionView.layoutIfNeeded()
			let indexPath = IndexPath(item: 0, section: section)
			if let attrs = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) {
				let leftInset = CGFloat(16)
				var targetX = attrs.frame.minX - leftInset
				let maxX = max(0, collectionView.contentSize.width - collectionView.bounds.width)
				targetX = min(max(0, targetX), maxX)
				collectionView.setContentOffset(CGPoint(x: targetX, y: collectionView.contentOffset.y), animated: true)
			} else {
				collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
			}
		}
	}
}

// MARK: - UICollectionViewDelegate

extension EmojiKeyboardView: UICollectionViewDelegate {
	func scrollViewWillEndDragging(
		_ scrollView: UIScrollView,
		withVelocity velocity: CGPoint,
		targetContentOffset: UnsafeMutablePointer<CGPoint>
	) {
		let proposedX = targetContentOffset.pointee.x
		let bounds = collectionView.bounds
		let layout = collectionView.collectionViewLayout
		let leftInset = CGFloat(16) // 24

		let searchRect = CGRect(
			x: max(proposedX - 200, 0),
			y: 0,
			width: bounds.width + 400,
			height: bounds.height
		)
		guard let attributes = layout.layoutAttributesForElements(in: searchRect)?.filter({ $0.representedElementCategory == .cell }),
			  !attributes.isEmpty else { return }

		// Ищем ближайшую «якорную» позицию с учетом требуемого левого отступа
		let nearest = attributes.min(by: { abs(($0.frame.minX - leftInset) - proposedX) < abs(($1.frame.minX - leftInset) - proposedX) })!
		var targetX = nearest.frame.minX - leftInset

		if abs(velocity.x) > 0.2 {
			if velocity.x > 0,
			   let next = attributes
					.filter({ ($0.frame.minX - leftInset) > (nearest.frame.minX - leftInset) })
					.min(by: { ($0.frame.minX - leftInset) < ($1.frame.minX - leftInset) }) {
				targetX = next.frame.minX - leftInset
			} else if velocity.x < 0,
					  let prev = attributes
					.filter({ ($0.frame.minX - leftInset) < (nearest.frame.minX - leftInset) })
					.max(by: { ($0.frame.minX - leftInset) < ($1.frame.minX - leftInset) }) {
				targetX = prev.frame.minX - leftInset
			}
		}

		let maxX = max(0, scrollView.contentSize.width - bounds.width)
		targetX = min(max(targetX, 0), maxX)

		targetContentOffset.pointee.x = targetX
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
		var bestSection = selectedCategory.rawValue
		var bestWidth: CGFloat = 0
		
		if let attrs = collectionView.collectionViewLayout.layoutAttributesForElements(in: visibleRect) {
			var widths: [Int: CGFloat] = [:]
			for a in attrs where a.representedElementCategory == .cell {
				widths[a.indexPath.section, default: 0] += a.frame.intersection(visibleRect).width
			}
			if let (sec, w) = widths.max(by: { $0.value < $1.value }) {
				bestSection = sec
				bestWidth = w
			}
		}
		if bestWidth > 0, bestSection != selectedCategory.rawValue, let newCat = EmojiCategory(rawValue: bestSection) {
			selectedCategory = newCat
		}
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let item = dataSource.itemIdentifier(for: indexPath) {
			insertText(item.emoji)
		}
	}
}
