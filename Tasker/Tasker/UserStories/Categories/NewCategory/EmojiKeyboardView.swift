//
//  EmojiKeyboardView.swift
//  Tasker
//
//  Created by Roman Apanasevich on 15.06.2025.
//

import UIKit

enum EmojiCategory: Int, CaseIterable {
	case smileys = 0
	case animals
	case food
	case activities
	case travel
	case objects
	case symbols
	case flags
	
	var image: UIImage {
		switch self {
		case .smileys: 		return UIImage(resource: .smile)
		case .animals: 		return UIImage(resource: .animal)
		case .food: 		return UIImage(resource: .food)
		case .activities: 	return UIImage(resource: .sport)
		case .travel:		return UIImage(resource: .vehicles)
		case .objects: 		return UIImage(resource: .object)
		case .symbols: 		return UIImage(resource: .symbol)
		case .flags: 		return UIImage(resource: .flag)
		}
	}
	
	var emojis: [String] {
		switch self {
		case .smileys:
			return EmojiCategory.makeEmojiStrings(from: [
				0x1F600...0x1F64F, // emoticons
				0x1F970...0x1F976, // additional smileys (🥰…🥶)
				0x1F917...0x1F92F, // 🤗 … 🤯
				0x1F9D0...0x1F9FF, // people faces/gestures (🧐 … 🧿)
			])
		case .animals:
			return EmojiCategory.makeEmojiStrings(from: [
				0x1F400...0x1F43F, // animals
				0x1F980...0x1F98C, // crab…butterfly
				0x1F99A...0x1F9A5, // additional animals
				0x1F331...0x1F337, // plants 🌱…🌷
				0x1F33C...0x1F341, // more plants 🌼…🍁
				0x1F33F...0x1F340, // herbs/clover
				0x1F324...0x1F32C, // weather
				0x2600...0x26C5     // sun…cloud
			])
		case .food:
			return EmojiCategory.makeEmojiStrings(from: [
				0x1F32D...0x1F37F, // food & drink
				0x1F950...0x1F95E, // additional food
				0x1F960...0x1F96F, // more food
				0x1F9C0...0x1F9CB  // cheese…beverage-box
			])
		case .activities:
			return EmojiCategory.makeEmojiStrings(from: [
				0x1F3A0...0x1F3FA, // activities
				0x1F6B4...0x1F6B6, // cyclists/pedestrians
				0x1F938...0x1F93E, // sports people
				0x26BD...0x26BE,   // ⚽️⚾️
				0x26F3...0x26F3,   // ⛳️
				0x1F3BE...0x1F3CE  // tennis…racing car
			])
		case .travel:
			return EmojiCategory.makeEmojiStrings(from: [
				0x1F680...0x1F6FF, // transport & places
				0x1F30D...0x1F3DD, // globe…buildings
				0x26F0...0x26FA    // mountain…tent
			])
		case .objects:
			return EmojiCategory.makeEmojiStrings(from: [
				0x1F4A1...0x1F4FD, // light bulb…film projector
				0x1F50A...0x1F579, // loud sound…joystick
				0x1F5A5...0x1F5FF, // desktop…
				0x1F9E0...0x1F9FF, // brain…
				0x1FA70...0x1FA95  // tools/objects (🧰…🪕)
			])
		case .symbols:
			return EmojiCategory.makeEmojiStrings(from: [
				0x1F300...0x1F5FF, // misc symbols & pictographs
				0x1F90D...0x1F93A, // ❤️‍🔥 etc., hands
				0x2700...0x27BF,   // dingbats (❤️, ✨, ➕)
				0x2194...0x21AA,   // arrows subset
				0x23E9...0x23FA,   // media symbols
				0x24C2...0x24C2,   // Ⓜ️
				0x3297...0x3299    // ☑️, ㊙️ ㊗️
			])
		case .flags:
			return EmojiCategory.flagEmojis()
		}
	}

	// MARK: - Helpers
	private static func makeEmojiStrings(from ranges: [ClosedRange<Int>]) -> [String] {
		// Flatten ranges into scalars, keep only valid emoji that render as standalone glyphs
		let scalars = ranges.flatMap { $0 }.compactMap { UnicodeScalar($0) }
		return scalars.compactMap { scalar in
			return String(Character(scalar))
		}
	}

	private static func flagEmojis() -> [String] {
		// Build flags from ISO region codes by mapping A..Z to regional indicators 0x1F1E6..0x1F1FF
		let base: UInt32 = 0x1F1E6
		return Locale.isoRegionCodes.compactMap { code in
			let upper = code.uppercased()
			guard upper.count == 2, upper.unicodeScalars.allSatisfy({ $0.value >= 65 && $0.value <= 90 }) else { return nil }
			let scalars = upper.unicodeScalars.map { UnicodeScalar(base + ($0.value - 65))! }
			return String(scalars.map { Character($0) })
		}
	}
}

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
				button.tintColor = .textPrimary
				button.backgroundColor = .secondaryGray
			} else {
				button.tintColor = .textSecondary
				button.backgroundColor = .clear
			}
		}
	}
	
	private func makeLayout() -> UICollectionViewCompositionalLayout {
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.scrollDirection = .horizontal
		config.interSectionSpacing = 32

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
			section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 11, trailing: 24)
			return section
		}, configuration: config)

		return layout
	}
	
	private func setupCollectionView() {
		let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, EmojiItem> { cell, indexPath, item in
			// Configure a lightweight label, centered
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
		let indexPath = IndexPath(item: 0, section: section)
		if dataSource.snapshot().sectionIdentifiers.indices.contains(section) {
			collectionView.scrollToItem(at: indexPath, at: section == 0 ? .centeredHorizontally : .left, animated: true)
		}
	}
}

// MARK: - UICollectionViewDelegate

extension EmojiKeyboardView: UICollectionViewDelegate {
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
