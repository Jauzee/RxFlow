//
//  DashboardViewController1.swift
//  RxFlowDemo
//
//  Created by Thibault Wittemberg on 17-07-26.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//

import UIKit
import Reusable
import RxFlow
import RxSwift
import RxCocoa

class WishlistViewController: UIViewController, StoryboardBased, ViewModelBased {

    @IBOutlet private weak var moviesTable: UITableView!

    var viewModel: WishlistViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForPreviewing(with: self, sourceView: moviesTable)
        self.moviesTable.delegate = self
        self.moviesTable.dataSource = self
    }
}

extension WishlistViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        viewModel.pick(movieId: viewModel.movies[0].id)
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let id = viewModel.movies[0].id
        let viewController = MovieDetailViewController.instantiate(withViewModel: MovieDetailViewModel(withMovieId: id), andServices: viewModel.services)
        viewController.title = viewController.viewModel.title
        return viewController
    }

}

extension WishlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.pick(movieId: self.viewModel.movies[indexPath.item].id)
    }
}

extension WishlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: MovieViewCell!

        if let movieViewCell = tableView.dequeueReusableCell(withIdentifier: "movieViewCell") as? MovieViewCell {
            cell = movieViewCell
        } else {
            cell = MovieViewCell()
        }

        cell.movieTitle.text = self.viewModel.movies[indexPath.item].title
        cell.movieImage.image = UIImage(named: self.viewModel.movies[indexPath.item].image)
        return cell
    }
}
