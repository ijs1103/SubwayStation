//
//  StationDetailViewController.swift
//  SubwayStation
//
//  Created by Eunyeong Kim on 2021/08/12.
//

import Alamofire
import SnapKit
import UIKit

final class StationDetailViewController: UIViewController {
    private let station: Station
    private var realtimeArrivalList: [StationArrivalDatResponseModel.RealTimeArrival] = []

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)

        return refreshControl
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(
            width: view.frame.width - 32.0,
            height: 100.0
        )
        // cell간 간격
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(StationDetailCollectionViewCell.self, forCellWithReuseIdentifier: "StationDetailCollectionViewCell")

        collectionView.dataSource = self

        collectionView.refreshControl = refreshControl

        return collectionView
    }()

    init(station: Station) {
        self.station = station

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = station.stationName

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }

        fetchData()
    }

    @objc private func fetchData() {
        let stationName = station.stationName
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName.replacingOccurrences(of: "역", with: ""))"

        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationArrivalDatResponseModel.self) { [weak self] response in
                // network의 성공실패여부와 관계없이 refreshControl의 로딩표시는 끝나야 하므로 먼저 작성.
                self?.refreshControl.endRefreshing()

                guard case .success(let data) = response.result else { return }

                self?.realtimeArrivalList = data.realtimeArrivalList
                self?.collectionView.reloadData()
            }
            .resume()
    }
}

extension StationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realtimeArrivalList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "StationDetailCollectionViewCell",
            for: indexPath
        ) as? StationDetailCollectionViewCell

        let realTimeArrival = realtimeArrivalList[indexPath.row]
        cell?.setup(with: realTimeArrival)

        return cell ?? UICollectionViewCell()
    }
}
