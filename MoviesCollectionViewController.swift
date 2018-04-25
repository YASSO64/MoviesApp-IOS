//
//  MoviesCollectionViewController.swift
//  MovieApp
//
//  Created by Sayed Abdo on 4/7/18.
//  Copyright © 2018 Sayed Abdo. All rights reserved.
//

import UIKit
import SDWebImage
import Dropdowns
import RealmSwift

private let reuseIdentifier = "cell";

class MoviesCollectionViewController: UICollectionViewController {
    
    var moviesObjs = Array<MovieDB>();
    var cachedMovies: Results<MovieDB>!;
    var favMovies: Results<MovieDB>!;
    var imageURLPrefix = "https://image.tmdb.org/t/p/w185";
    var imgs = [String]();
    let movieDaoInstance = MovieDAO.getInstance();
    
    // for spacing between cells...
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0);
    let numberOfItemsPerRow : CGFloat = 2;
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        print("in didLoad");
        navigationController?.navigationBar.isTranslucent = false;
        navigationController?.navigationBar.barTintColor =  UIColor.white;
        
        //movieDaoInstance.clearCache();
        
        if Connectivity.isConnectedToInternet() {
            print("internet is available");
            API.getMoviesFromApi(view: self);
        }
        else {
            print("internet isn't available");
            cachedMovies = getCachedMovies();
            //favMovies = getFavCachedMovies();
            loadCachedMovies(movies: cachedMovies);
        }
        
        //setupNavigationItem();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  API.getMoviesFromApi(view: self);
        setupNavigationItem();
    }
    
    func setupNavigationItem() {
        let menuItems = ["Most Popular", "Top Rated"];
        let titleView = TitleView(navigationController: navigationController!, title: "Menu", items: menuItems);
        var sortCriteria = "";
        titleView?.action = { [weak self] index in
            print("select \(index)");
            if index == 0 {
                sortCriteria = "popularity.asc";
                API.getSortedMoviesFromApi(view:self!, sort:sortCriteria);
            }
            if index == 1 {
                sortCriteria = "vote_average.asc";
                API.getSortedMoviesFromApi(view:self!, sort:sortCriteria);
            }
        }
        
        navigationItem.titleView = titleView;
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("imgs count from numOfRows: \(imgs.count)");
        return (imgs.count);
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("in collectionview");
        
        let myCell: MyCustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCustomCollectionViewCell;
        
        let imgUrl:URL = URL(string: imgs[indexPath.row])!;
        myCell.myImgView.sd_setImage(with: imgUrl, completed:nil);
        
        return myCell;
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedMovie = moviesObjs[indexPath.row];
        let detailsView = self.storyboard?.instantiateViewController(withIdentifier: "detailsViewId") as! DetailsViewController;
        detailsView.selectedMovie = selectedMovie;
        self.navigationController?.pushViewController(detailsView, animated: true);
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    func loadMovies(movies:Array<MovieDB>){
        moviesObjs.append(contentsOf: movies);
        loadMoviesImgs();
    }
    
    func getCachedMovies() -> Results<MovieDB> {
        let cachedMovs: Results<MovieDB> = movieDaoInstance.getMovies();
        return cachedMovs;
    }
    
    func getFavCachedMovies() -> Results<MovieDB> {
        let favCachedMovs: Results<MovieDB> = movieDaoInstance.getFavMovies();
        return favCachedMovs;
    }
    
    func loadCachedMovies(movies:Results<MovieDB>){
        moviesObjs.append(contentsOf: movies);
        loadMoviesImgs();
    }
    
    func loadMoviesImgs(){
        for i in 0..<(moviesObjs.count) {
            let imgPath = moviesObjs[i].posterPath;
            imgs.append(imgPath);
            print("image path: \(imgPath)");
        }
        print("imgs count from loadMoviesImgs count: \(imgs.count)");
        self.collectionView?.reloadData();
    }
}

// for spacing between cells...
extension MoviesCollectionViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (numberOfItemsPerRow);
        let availableWidth = view.frame.width - paddingSpace;
        let widthPerItem = availableWidth / numberOfItemsPerRow;
        
        return CGSize(width: widthPerItem, height: widthPerItem);
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets;
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left;
    }
}

