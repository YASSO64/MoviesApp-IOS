//
//  MovieDAO.swift
//  MovieApp
//
//  Created by Sayed Abdo on 4/14/18.
//  Copyright © 2018 Sayed Abdo. All rights reserved.
//

import UIKit
import RealmSwift

class MovieDAO: NSObject {

    static let instance = MovieDAO();
    private static let realm = try! Realm();
    
    override private init() {
        let folderPath = MovieDAO.realm.configuration.fileURL!.deletingLastPathComponent().path;
        try! FileManager.default.setAttributes([FileAttributeKey(rawValue: "NSFileProtectionKey"): FileProtectionType.none],ofItemAtPath: folderPath);
    }
    
    class func getInstance() -> MovieDAO {
        return MovieDAO.instance;
    }
    
    func insertMovie(movieObj: MovieDB) {
        try! MovieDAO.realm.write {
            MovieDAO.realm.add(movieObj);
            print("movie has been inserted into DB");
        }
    }
    
    func getMovies() -> Results<MovieDB> {
        let movies: Results<MovieDB> = MovieDAO.realm.objects(MovieDB.self).filter("isFav=%@", false);
        print("cached movies count from DB: \(movies.count)");
        return movies;
    }
    
    func getFavMovies () -> Results<MovieDB> {
        let movies: Results<MovieDB> = MovieDAO.realm.objects(MovieDB.self).filter("isFav=%@", true);
        print("fav cached movies count from DB: \(movies.count)");
        return movies;
    }
    
    func isMovieCachedBefore(movieObj: MovieDB) -> Bool {
        let res: Results<MovieDB> = MovieDAO.realm.objects(MovieDB.self).filter("id=%@", movieObj.id);
        if res.isEmpty {
            return false;
        }
        return true;
    }
    
    func isFavMovie(movieObj: MovieDB) -> Bool {
        return (movieObj.isFav);
    }
    
    func removeMovie(movieObj: MovieDB) {
        try! MovieDAO.realm.write {
            MovieDAO.realm.delete(movieObj);
            print("movie has been removed from homeCachedMovies");
        }
    }
    
    func clearCache() {
        try! MovieDAO.realm.write {
            MovieDAO.realm.deleteAll();
            print("cached movies has been deleted");
        }
    }
    
}
