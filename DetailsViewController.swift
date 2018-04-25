//
//  DetailsViewController.swift
//  MovieApp
//
//  Created by Sayed Abdo on 4/9/18.
//  Copyright © 2018 Sayed Abdo. All rights reserved.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var reviewHeadingLbl: UILabel!
    @IBOutlet weak var trailerHeadingLbl: UILabel!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var movieImgView: UIImageView!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var movieOverviewTxtView: UITextView!
    @IBOutlet weak var trailersTableView: UITableView!
    @IBOutlet weak var reviewsTableView: UITableView!
    
    //var selectedMovie: MovieModel?;
    //var selectedCachedMovie: MovieDB?;
    var selectedMovie: MovieDB?;
    let trailerResuseIdentifier = "trailerCell";
    let reviewResuseIdentifier = "reviewCell";
    var trailersCount = 0;
    var reviewsCount = 0;
    var trailersKeys = Array<String>();
    var reviews = Array<ReviewDB>();
    var reviewsContents = Array<String>();
    var authors = Array<String>();
    var isFav = false;
    let movieDaoInstance = MovieDAO.getInstance();
    
    @IBAction func addToFavAction(_ sender: Any) {
        isFav = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();

        movieTitleLbl.text = selectedMovie!.title;
        print(selectedMovie!.title);
        releaseDateLbl.text = selectedMovie!.releaseDate;
        ratingLbl.text = "\(selectedMovie!.rating)";
        print("\(selectedMovie!.rating)");
        movieOverviewTxtView.text = selectedMovie!.overview;
        print(selectedMovie!.posterPath);
        let imgUrl:URL = URL(string: selectedMovie!.posterPath)!;
        movieImgView.sd_setImage(with: imgUrl, completed: nil);
        
        if Connectivity.isConnectedToInternet() {
            API.getTrailersFromApi(movieId: (selectedMovie?.id)!, view: self);
           // API.getReviewsFromApi(movieId: (selectedMovie?.id)!, view: self);
            
        }
        
        else {
            self.reviews.append(contentsOf: selectedMovie!.reviews);
            setReviewsCount(reviews_count: self.reviews.count);
            setReviews(reviewsArr: self.reviews);
    
            for trailerKey in selectedMovie!.trailersKeys {
                print("cached trailers keys: \(trailerKey)");
            }
            
            self.trailersKeys.append(contentsOf: selectedMovie!.trailersKeys);
            setTrailersCount(trailers_count: self.trailersKeys.count);
            setTrailersKeys(trailersKeysArr: self.trailersKeys);
        }
        
        trailerHeadingLbl.layer.cornerRadius = 10.0;
        trailersTableView.layer.cornerRadius = 10.0;
        reviewHeadingLbl.layer.cornerRadius = 10.0;
        reviewsTableView.layer.cornerRadius = 10.0;
        favBtn.layer.cornerRadius = 5.0;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("number of sections method");
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        var count: Int?
        let rowHeight:CGFloat = tableView.rowHeight;
        var tableHeight:CGFloat?
        
        if tableView == self.trailersTableView {
            count = trailersCount;
            //print("trailers count : \(count!)");
            tableHeight = CGFloat(count!) * rowHeight;
            tableView.frame = CGRect(x: 8.0, y: 448.0, width: 300.0, height: tableHeight!);
        }
        if tableView == self.reviewsTableView {
            count = reviewsCount;
            print("reviews count : \(count!)");
            tableHeight = CGFloat(count!) * rowHeight;
            reviewHeadingLbl.frame = CGRect(x: 8.0, y: 448+trailersTableView.frame.height+10, width: 300.0, height: 35.0);
            tableView.frame = CGRect(x: 8.0, y: 448+trailersTableView.frame.height+45, width: 300.0, height: tableHeight!);
        }
        return count!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("cellForRowAtIndexpath");
        
        if tableView == self.trailersTableView {
            //print("trailer cell");
            let myCell = tableView.dequeueReusableCell(withIdentifier: trailerResuseIdentifier, for: indexPath) as! TrailersTableViewCell;
            
            myCell.trailerTitleLbl.text = "Trailer \((indexPath.row) + 1)";
            myCell.trailerTitleLbl.textColor = UIColor(displayP3Red: 0, green: 0, blue: 255, alpha: 0.7);
            let img = UIImage(named: "play-icon.png");
            myCell.playVideoImgView.image = img;
            return myCell;
        }
        else {
            print("review cell");
            let myCell = tableView.dequeueReusableCell(withIdentifier: reviewResuseIdentifier, for: indexPath) as! ReviewsTableViewCell;
            
            myCell.reviewTxtView.textColor = UIColor(displayP3Red: 0, green: 0, blue: 255, alpha: 0.7);
            myCell.authorLbl.textColor = UIColor(displayP3Red: 25, green: 0, blue: 0, alpha: 0.7);
            
            print("review : \(reviewsContents[indexPath.row])");
        
            myCell.reviewTxtView.text = reviewsContents[indexPath.row];
            myCell.authorLbl.text = "written by: '\(authors[indexPath.row])'";

            return myCell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.trailersTableView {
            let youtubePlayerView = self.storyboard?.instantiateViewController(withIdentifier: "youtubePlayerViewId") as! YoutubePlayerViewController;
            youtubePlayerView.trailerKey = self.trailersKeys[indexPath.row];
            self.navigationController?.pushViewController(youtubePlayerView, animated: true);
        }
        else {}
    }
    
    func setTrailersCount(trailers_count: Int) {
        trailersCount = trailers_count;
        //print("trailers count from tableview: \(trailersCount)");
    }
    
    func setTrailersKeys(trailersKeysArr: Array<String>) {
        trailersKeys.append(contentsOf: trailersKeysArr);
        trailersTableView.reloadData();
    }
    
    func setReviewsCount(reviews_count: Int) {
        reviewsCount = reviews_count;
        //print("reviews count from tableview: \(reviewsCount)");
    }

    func setReviews(reviewsArr: Array<ReviewDB>) {
        self.reviews.append(contentsOf: reviewsArr);
        if self.reviews.count == 0 {
            reviewHeadingLbl.textColor = UIColor.white;
            reviewHeadingLbl.backgroundColor = UIColor.white;
        }
        for review in self.reviews {
            reviewsContents.append(review.content);
            print("check review content: \(review.content)");
            authors.append(review.author);
            print("check review author: \(review.author)");
            prepareMovieToBeCached();
            self.reviewsTableView.reloadData();
        }
    }
    
    func prepareMovieToBeCached() {
        let myMovie = MovieDB();
        myMovie.id = selectedMovie!.id;
        myMovie.title = selectedMovie!.title;
        myMovie.overview = selectedMovie!.overview;
        myMovie.releaseDate = selectedMovie!.releaseDate;
        myMovie.posterPath = selectedMovie!.posterPath;
        myMovie.rating = selectedMovie!.rating;
        myMovie.isFav = self.isFav;
        myMovie.reviews.append(objectsIn: self.reviews);
        myMovie.trailersKeys.append(objectsIn: self.trailersKeys);
       
        print("trailersKeys count from prepareForCaching: \(trailersKeys.count)");
        print("myMovie trailerKeys count from prepareForCaching: \(myMovie.trailersKeys.count)");
//        for trailerKey in trailersKeys {
        //            print("trailers keys to be cached: \(trailerKey)");
//        }
//        for trailerKey in myMovie.trailersKeys {
//            print("myMovie trailers keys to be cached: \(trailerKey)");
//        }
        
        if movieDaoInstance.isMovieCachedBefore(movieObj: myMovie) == false {
            movieDaoInstance.insertMovie(movieObj: myMovie);
        }
        else {
            print("the movie already cached before");
        }
    }
}
