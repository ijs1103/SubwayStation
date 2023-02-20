# SubwayStation

![Simulator Screen Recording - iPod touch (7th generation) - 2023-02-20 at 19 31 35](https://user-images.githubusercontent.com/42196410/220082179-167f5f78-5414-4004-a073-754e47c790d3.gif)
![Simulator Screen Recording - iPod touch (7th generation) - 2023-02-20 at 19 49 22](https://user-images.githubusercontent.com/42196410/220084666-9a07530e-2387-4a98-b389-295bfd878377.gif)



## 🧩 개요

- 검색창 자동완성 기능
- UIRefreshControl로 서버 데이터 refetch 기능

## 🤔 배운 내용

### ✔️ 검색창 자동완성 기능

`UISearchBar`에서 유저의 입력이 끝나는 시점인 `textDidChange`에서 서버 데이터를 요청하고 UITableView에 표시하면 자동완성 기능구현 완성.

### ✔️ UIRefreshControl로 서버 데이터 refetch 기능

`UICollectionView`의 멤버인 `UIRefreshControl`로 UI를 구현한다.

```swift

// 선언부
private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        return refreshControl
}()

// UIRefreshControl 종료시

refreshControl.endRefreshing()

```
