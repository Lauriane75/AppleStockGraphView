//
//  ViewController.swift
//  stock
//
//  Created by Christophe Bugnon on 5/21/20.
//  Copyright © 2020 Christophe Bugnon. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Outlets

    private var scrollView: UIScrollView!
    private var containerView: UIView!

    private var headerView: UIView!

    private var collectionView: UICollectionView!

    private var graphView: GraphView

    private var titleLabel: UILabel!
    private var nameLabel: UILabel!
    private var titleOutlineView: UIView!
    private var atCloseLabel: UILabel!
    private var inflationLabel: UILabel!
    private var atCloseOutlineView: UIView!

    // MARK: - Properties

    var viewModel = HomeViewModel.shared

    lazy var contentViewSize: CGSize = {
        return CGSize(width: view.frame.width, height: view.frame.height + Constants.heightScrollView)
    }()

    // MARK: - Initializer

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.graphView = GraphView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        implementOutlets()

        bind(to: viewModel)

        graphView.isUserInteractionEnabled = true
        graphView.isMultipleTouchEnabled = true

        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Bind

    private func bind(to viewModel: HomeViewModel) {
        viewModel.visibleItems = { [weak self] items in
            guard let self = self else { return }
            guard let firstItem = items.first else { return }
            self.graphView.updateWithValues(firstItem)
            self.titleLabel.text = firstItem.symbol
            self.nameLabel.text = firstItem.name
            self.atCloseLabel.text = firstItem.atClose
            self.inflationLabel.text = firstItem.inflation
        }
    }
}

// MARK: - Outlets

extension HomeViewController {

    fileprivate func implementOutlets() {
        scrollView = returnScrollView()

        containerView = returnView()
        containerViewConstraints()

        titleLabel = returnLabel(font: UIFont.systemFont(ofSize: 24))
        titleLabelConstraints()

        nameLabel = returnLabel(tintColor: .gray)
        nameLabelConstraints()

        titleOutlineView = returnView(backgroundColor: .gray)
        titleOutlineViewConstraints()

        atCloseLabel = returnLabel(tintColor: .white)
        atCloseLabelConstraints()

        inflationLabel = returnLabel(tintColor: .green)
        inflationLabelConstraints()

        atCloseOutlineView = returnView(backgroundColor: .gray)
        atCloseOutlineViewConstraints()

        containerView.addSubview(graphView)
        graphViewConstraints()
    }
}

// MARK: - Constraints

extension HomeViewController {

    fileprivate func containerViewConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1)
        ])
        containerView.center = view.center
    }

    fileprivate func headerViewConstraints() {
          NSLayoutConstraint.activate([
              headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
              headerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
              headerView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.11),
              headerView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1)
          ])
          headerView.center = view.center
      }

    fileprivate func collectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.topAnchor),
            collectionView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            collectionView.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 1),
            collectionView.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 1)
        ])
        collectionView.center = headerView.center
    }

    fileprivate func titleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    fileprivate func nameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 80),
            nameLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 2),
            nameLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    fileprivate func atCloseLabelConstraints() {
        NSLayoutConstraint.activate([
            atCloseLabel.topAnchor.constraint(equalTo: titleOutlineView.bottomAnchor, constant: 10),
            atCloseLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            atCloseLabel.heightAnchor.constraint(equalToConstant: 30),
            atCloseLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    fileprivate func inflationLabelConstraints() {
        NSLayoutConstraint.activate([
            inflationLabel.topAnchor.constraint(equalTo: atCloseLabel.topAnchor),
            inflationLabel.leadingAnchor.constraint(equalTo: atCloseLabel.trailingAnchor),
            inflationLabel.heightAnchor.constraint(equalTo: atCloseLabel.heightAnchor),
            inflationLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    fileprivate func titleOutlineViewConstraints() {
        NSLayoutConstraint.activate([
            titleOutlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleOutlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleOutlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            titleOutlineView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }

    fileprivate func atCloseOutlineViewConstraints() {
        NSLayoutConstraint.activate([
            atCloseOutlineView.topAnchor.constraint(equalTo: atCloseLabel.bottomAnchor, constant: 10),
            atCloseOutlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            atCloseOutlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            atCloseOutlineView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }

    fileprivate func graphViewConstraints() {
        graphView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            graphView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            graphView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 280),
            graphView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -40),
            graphView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.4)
        ])
    }
}

// MARK: - Views

extension HomeViewController {

    func returnScrollView(backgroundColor: UIColor = Constants.gridGray) -> UIScrollView {
        let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.frame = view.bounds
            scrollView.contentSize = contentViewSize
            scrollView.autoresizingMask = .flexibleHeight
            scrollView.bounces = true
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.backgroundColor = backgroundColor
            return scrollView
        }()
        view.addSubview(scrollView)
        return scrollView
    }

    func returnView(backgroundColor: UIColor = Constants.gridGray) -> UIView {
        let view: UIView = {
            let viewContainer = UIView()
            viewContainer.translatesAutoresizingMaskIntoConstraints = false
            viewContainer.backgroundColor = backgroundColor
            viewContainer.frame.size = contentViewSize
            return viewContainer
        }()
        scrollView.addSubview(view)
        return view
    }

    func returnLabel(tintColor: UIColor = .white, font: UIFont = UIFont.systemFont(ofSize: 14)) -> UILabel {
        let label: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = tintColor
            label.font = font
            return label
        }()
        containerView.addSubview(label)
        return label
    }
}
