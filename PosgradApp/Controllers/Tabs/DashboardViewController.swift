//
//  DashboardViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 14/02/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit
import Charts
import Firebase

enum Phases: String {
    case phase1 = "Temporada 1"
    case phase2 = "Temporada 2"
    case phase3 = "Temporada 3"
    case phase4 = "Temporada 4"
    case phase5 = "Temporada 5"
    case phase6 = "Temporada 6"
    case phase7 = "Temporada 7"
    case phase8 = "Temporada 8"
    static let order = [phase1, phase2, phase3, phase4, phase5, phase6, phase7, phase8]
}

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, ChartViewDelegate, ClassDashboardCellDelegate {
        
    @IBOutlet weak var tableView: UITableView!
    private var optionsTableView: UITableView? = nil
    
    var navBarProfileImageView = UIImageView(image: UIImage(named: "account_circle_white")?.withRenderingMode(.alwaysTemplate))
    
    var refreshControl: UIRefreshControl!

    var missions = [String : Mission]()
    var missionsOrder = [String]()
    var teams = [String : Team]()
    var teamsOrder = [String]()
    var teamMembersByID = [String : TeamMember]()
    var activities = [TeamActivity]()
    var charts = [Chart?]()
    
    var database: Firestore!
    
    // True if it's the first time the view is loading
    var firstLoad = true
    // True if any request has failed
    var failedRequest = false
    
    // The number of expected requests
    var numberOfRequests = 3
    // Counts how many graph related requests have successfully finished
    var successfulRequests = 0
    // Counts how many graph related requests have unsuccessfully finished
    var unsuccessfulRequests = 0
    // Is true if table view needs to refresh
    var reloadData = false
    
    // The mission selected in the selected cell chart
    var selectedCellMission: Int!
    // The points of the selected mission in the selected cell chart
    var selectedCellPoints: Double!
    // The indexpath row number of the selected cell
    var selectedCellRow: Int!
    // The team of the selected cell
    var selectedCellTeam: String!
    
    // MARK: - View life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDelegates()
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        //initSearchBar()
        initProfileNavBarButton(imageView: self.navBarProfileImageView)
        initFirebase()
        initRefreshControl()
        
        numberOfRequests = 3
        retrieveAndUptadeGraphsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navBarProfileImageView.isHidden {
            self.navBarProfileImageView.isHidden = false
        }
        self.navigationItem.title = "Dashboard"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationItem.title = nil
        if !self.navBarProfileImageView.isHidden {
            self.navBarProfileImageView.isHidden = true
        }
    }
    
    // MARK: - Set up retrieve firestore data functions
    func retrieveAndUptadeGraphsData () {
        retrieveGraphsData(completion: {
            (success) in
            self.successfulRequests = 0
            self.unsuccessfulRequests = 0
            if success {
                // Toda as requisições foram realizadas com sucesso
                self.updateGraphs()
            } else {
                // Não foi possível realizar todas as requisições com sucesso
                self.failedRequest = true
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        })
    }
    
    // Retrieve the all documents from the teams collection, all the missions from the missions collection and the user data if it's the first time loading, it completes when all requests are completed
    func retrieveGraphsData (completion: @escaping (Bool) -> ()) {
        self.teamsOrder.removeAll()
        self.charts.removeAll()
        
        if reloadData {
            self.teamsOrder.insert(appDelegate.user.team!.documentID, at: 0)
            let newChart = Chart()
            self.charts.insert(newChart, at: 0)
            
            self.tableView.reloadData()
        } else {
            self.appDelegate.user.retrieveUserData(database: self.database, completion: {
                (success, user) in
                if success {
                    if let avatarImage = self.appDelegate.user.avatar {
                        self.navBarProfileImageView.image = avatarImage
                    }
                    self.teamsOrder.insert(user!.team!.documentID, at: 0)
                    let newChart = Chart()
                    self.charts.insert(newChart, at: 0)
                    
                    self.successfulRequests += 1
                    if self.successfulRequests == self.numberOfRequests {
                        completion(true)
                    }
                } else {
                    self.unsuccessfulRequests += 1
                    if (self.successfulRequests + self.unsuccessfulRequests) == self.numberOfRequests {
                        completion(false)
                    }
                }
            })
        }
        
        retrieveTeams {
            (success) in
            if success {
                self.successfulRequests += 1
                if self.successfulRequests == self.numberOfRequests {
                    completion(true)
                }
            } else {
                self.unsuccessfulRequests += 1
                if (self.successfulRequests + self.unsuccessfulRequests) == self.numberOfRequests {
                    completion(false)
                }
            }
        }
        retrieveMissions {
            (success) in
            if success {
                self.successfulRequests += 1
                if self.successfulRequests == self.numberOfRequests {
                    completion(true)
                }
            } else {
                self.unsuccessfulRequests += 1
                if (self.successfulRequests + self.unsuccessfulRequests) == self.numberOfRequests {
                    completion(false)
                }
            }
        }
    }
    
    // Retrieve all activities based on the team and update the table view
    func updateGraphs () {
        let userTeam = self.appDelegate.user.team?.documentID
        for teamDictionary in self.teams {
            let team = teamDictionary.value
            self.retrieveActivitiesByTeam(team: team, completion: {
                (success) in
                if team.ID == userTeam {
                    if success {
                        let userTeam = self.teamsOrder[0]
                        var sliderY = self.teams[userTeam]?.scoreArrayDic
                        if sliderY?.count == 0 {
                            sliderY = [["Missão Discovery" : 0.0,
                                        "Missão Startup" : 0.0,
                                        "Missão Passport" : 0.0,
                                        "Missão Curiosity" : 0.0]]
                        }
                        self.charts[0]!.initUserTeamChart(sliderY: sliderY![0]!)
                    } else {
                        self.failedRequest = true
                        self.charts[0] = nil
                    }
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    self.tableView.endUpdates()
                } else {
                    self.teamsOrder.append(team.ID!)
                    let row = self.teamsOrder.count - 1
                    if success {
                        let newChart = Chart()
                        let nextTeam = self.teamsOrder[row]
                        var sliderY = self.teams[nextTeam]?.scoreArrayDic
                        if sliderY?.count == 0 {
                            sliderY = [["Missão Discovery" : 0.0,
                                        "Missão Startup" : 0.0,
                                        "Missão Passport" : 0.0,
                                        "Missão Curiosity" : 0.0]]
                        }
                        newChart.initOthersTeamChart(sliderY: sliderY![0]!)
                        self.charts.append(newChart)
                    } else {
                        self.failedRequest = true
                        self.charts.append(nil)
                    }
                    let indexPath = IndexPath(row: row, section: 0)
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [indexPath], with: .none)
                    self.tableView.endUpdates()
                }
            })
        }
    }
    
    // Refresh the data of all the graphs when the refresh control is activated
    @objc func refreshGraphs () {
        reloadData = true
        numberOfRequests = 2
        retrieveAndUptadeGraphsData()
    }
    
    // MARK: - Retrieve firestore data
    // Retrieve all activities of a certain team and sums the score of a season and mission
    func retrieveActivitiesByTeam (team: Team, completion: @escaping (Bool) -> ()) {
        database.collection(TeamActivityKeys.collectionKey).whereField(TeamActivityKeys.teamKey, isEqualTo: team.reference!).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                var teamActivities = [TeamActivity]()
                for document in querySnapshot!.documents {
                    if let documentData = document.data() as? [String : Any] {
                        if let missionReference = documentData[TeamActivityKeys.missionKey] as? DocumentReference {
                            let missionName = self.missions[missionReference.documentID]?.name
                            let missionOrder = self.missions[missionReference.documentID]?.order
                            var newScore : Double
                            if let score = documentData[TeamActivityKeys.scoreKey] as? Double {
                                newScore = score
                            } else {
                                newScore = 0.0
                            }
                            team.updateScore(phase: 0, mission: missionName!, newScore: newScore)
                            
                            let newFile = documentData[TeamActivityKeys.fileKey] as? String
                            let newAppraiser = documentData[TeamActivityKeys.appraiserKey] as? String
                            let newFeedback = documentData[TeamActivityKeys.feedbackKey] as? String
                            let newMember = documentData[TeamActivityKeys.memberKey] as? DocumentReference
                            let newMission = documentData[TeamActivityKeys.missionKey] as? DocumentReference
                            let newName = documentData[TeamActivityKeys.nameKey] as? String
                            let newMissionScore = documentData[TeamActivityKeys.scoreKey] as? Int
                            let newTeam = documentData[TeamActivityKeys.teamKey] as? DocumentReference
                            let newType = documentData[TeamActivityKeys.typeKey] as? String
                            let newActivity = TeamActivity.init(file: newFile, appraiser: newAppraiser, feedback: newFeedback, member: newMember, mission: newMission, name: newName, score: newMissionScore, type: newType, team: newTeam, ID: document.documentID)
                            teamActivities.append(newActivity)
                            self.teams[team.ID!]!.activitiesByPhase[missionOrder!] = teamActivities
                        }
                    }
                }
                completion(true)
            }
        }
    }
    
    // Retrieve all mission documents from collection
    func retrieveMissions (completion: @escaping (Bool) -> ()) {
        database.collection(MissionKeys.collectionKey).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                self.missions.removeAll()
                self.missionsOrder = ["Passport",
                                      "Curiosity",
                                      "Discovery",
                                      "Startup"]
                for document in querySnapshot!.documents {
                    if let documentData = document.data() as? [String : Any] {
                        let newDescription = documentData[MissionKeys.descrptionKey] as? String
                        let newName = documentData[MissionKeys.nameKey] as? String
                        let newOrder = documentData[MissionKeys.orderKey] as? Int
                        let newSeason = documentData[MissionKeys.seasonKey] as? DocumentReference
                        let newMission = Mission(description: newDescription, name: newName, order: newOrder, season: newSeason, ID: document.documentID)
                        self.missions[document.documentID] = newMission
                        self.missionsOrder[newOrder! - 1] = document.documentID
                    }
                }
                completion(true)
            }
        }
    }
    
    // Retrieve all team documents from collection
    func retrieveTeams (completion: @escaping (Bool) -> ()) {
        database.collection(TeamKeys.collectionKey).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                self.teams.removeAll()
                
                for document in querySnapshot!.documents {
                    if let documentData = document.data() as? [String : Any] {
                        let newAvatar = documentData[TeamKeys.avatarKey] as? DocumentReference
                        let ID = document.documentID
                        let reference = document.reference
                        let newTeam = Team.init(reference: reference, avatar: newAvatar, ID: ID)
                        self.teams[ID] = newTeam
                    }
                }
                completion(true)
            }
        }
    }
    
    // Retrieve all members from collection
    func retrieveTeamMembers (completion: @escaping (Bool) -> ()) {
        database.collection(TeamMemberKeys.collectionKey).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                self.teamMembersByID.removeAll()
                for document in querySnapshot!.documents {
                    if let documentData = document.data() as? [String : Any] {
                        let newCourse = documentData[TeamMemberKeys.courseKey] as? String
                        let newEmail = documentData[TeamMemberKeys.emailKey] as? String
                        let newTeamID = documentData[TeamMemberKeys.teamIDKey] as? DocumentReference
                        let newName = documentData[TeamMemberKeys.nameKey] as? String
                        let ID = document.documentID
                        let newTeamMember = TeamMember.init(course: newCourse, email: newEmail, teamID: newTeamID, name: newName, ID: ID)
                        self.teamMembersByID[ID] = newTeamMember
                    }
                }
                completion(true)
            }
        }
    }
    
    //MARK: - View initializers
    func initDelegates () {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func initSearchBar () {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Procurar"
        searchController.searchBar.tintColor = UIColor.white
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func initFirebase () {
        database = Firestore.firestore()
        let settings = database.settings
        settings.areTimestampsInSnapshotsEnabled = true
        database.settings = settings
    }
    
    func initRefreshControl () {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector (self.refreshGraphs), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - General functions
    // Add delegate method of UIScrollView and call the method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height, imageView: navBarProfileImageView)
    }
    
    // MARK: - TableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.teamsOrder.count == 0 {
            return 1
        }
        return self.teamsOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.firstLoad || self.reloadData {
            self.firstLoad = false
            self.reloadData = false
            let cell = tableView.dequeueReusableCell(withIdentifier: "chartLoadingTableViewCell", for: indexPath) as! DashboardLoadingChartTableViewCell
            cell.activityIndicator.startAnimating()
            tableView.separatorStyle = .none
            return cell
        } else if self.failedRequest {
            self.failedRequest = false
            let cell = tableView.dequeueReusableCell(withIdentifier: "chartLoadingTableViewCell", for: indexPath) as! DashboardLoadingChartTableViewCell
            cell.activityIndicator.stopAnimating()
            cell.loadingLabel.text = "Não foi possível obter os dados dos times, tente novamente mais tarde."
            tableView.separatorStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chartTableViewCell", for: indexPath) as! DashboardChartTableViewCell

        tableView.separatorStyle = .singleLine
        cell.selectionStyle = .none
        
        if let cellChart = charts[indexPath.row] {
            cell.configButton.layer.cornerRadius = 18
            if cellChart.lineChartShouldBeActive {
                cell.configButton.setImage(UIImage(named:"bar_chart_black_48dp")?.withRenderingMode(.alwaysTemplate), for: .normal)
            } else {
                cell.configButton.setImage(UIImage(named:"show_chart_black_48dp")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
            cell.configButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
            cell.configButton.layer.borderWidth = 1
            cell.configButton.backgroundColor = UIColor.clear
            
            if indexPath.row == 0 {
                let userTeam = self.appDelegate.user.team?.documentID
                
                cell.initChart(chart: cellChart, indexPathRow: indexPath.row)
                cell.teamLabel.text = userTeam
                cell.backgroundColor = UIColor.darkGray
                cell.teamLabel.textColor = UIColor.white
                cell.configButton.layer.borderColor = UIColor.white.cgColor
                cell.configButton.tintColor = UIColor.white
                cell.delegate = self
            } else {
                let nextTeam = self.teamsOrder[indexPath.row]
                
                cell.initChart(chart: cellChart, indexPathRow: indexPath.row)
                cell.teamLabel.text = nextTeam
                cell.backgroundColor = UIColor.white
                cell.teamLabel.textColor = UIColor.black
                cell.configButton.layer.borderColor = UIColor.black.cgColor
                cell.configButton.tintColor = UIColor.black
                cell.delegate = self
                cell.chartView.setNeedsLayout()
            }
            return cell
        } else {
            cell.configButton.isEnabled = false
            cell.configButton.layer.cornerRadius = 18
            cell.configButton.setImage(UIImage(named:"bar_chart_black_48dp")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.configButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
            cell.configButton.layer.borderWidth = 1
            cell.configButton.backgroundColor = UIColor.clear

            if indexPath.row == 0 {
                let userTeam = self.appDelegate.user.team?.documentID
                
                cell.initFailureChart(indexPathRow: indexPath.row)
                cell.teamLabel.text = userTeam
                cell.backgroundColor = UIColor.darkGray
                cell.teamLabel.textColor = UIColor.white
                cell.configButton.layer.borderColor = UIColor.white.cgColor
                cell.configButton.tintColor = UIColor.white
                cell.delegate = self
            } else {
                let nextTeam = self.teamsOrder[indexPath.row]
                
                cell.initFailureChart(indexPathRow: indexPath.row)
                cell.teamLabel.text = nextTeam
                cell.backgroundColor = UIColor.white
                cell.teamLabel.textColor = UIColor.black
                cell.configButton.layer.borderColor = UIColor.black.cgColor
                cell.configButton.tintColor = UIColor.black
                cell.delegate = self
                cell.chartView.setNeedsLayout()
            }
            return cell
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    // MARK: - Delegation functions
    func segueToMissionDetail(mission: Double, points: Double, cellRow: Int, cellTeam: String) {
        self.selectedCellMission = Int(mission)
        self.selectedCellPoints = points
        self.selectedCellRow = cellRow
        self.selectedCellTeam = cellTeam
        performSegue(withIdentifier: "dashboardToMissionDetails", sender: self)
    }
    
    func changeChartType (cellRow: Int, completion: @escaping (Chart) -> ()) {
        if let chart = charts[cellRow] {
            if chart.lineChartShouldBeActive {
                chart.changeToBarChart()
            } else {
                chart.changeToLineChart()
            }
            completion(chart)
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dashboardToMissionDetails" {
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            
            let destinationVC = segue.destination as! MissionDetailsViewController
            
            let missionID = missionsOrder[selectedCellMission]
            destinationVC.team = teams[selectedCellTeam]
            destinationVC.season = 0
            destinationVC.mission = missions[missionID]
            destinationVC.totalPoints = selectedCellPoints
            destinationVC.missionActivities = teams[selectedCellTeam]?.activitiesByPhase[selectedCellMission]
        }
        if segue.identifier == "dashboardToProfile" {
            let destinationVC = segue.destination as! ProfileViewController
        }
    }
}
