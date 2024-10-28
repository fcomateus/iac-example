const search = async () => {
    const rawData = await fetch('https://api.github.com/users') 
    const users = await rawData.json()
    console.log(users);
    
    const list = document.getElementById('results')
    for(const user of users) {
        const listItem = document.createElement('li')
        
        const { login, html_url, avatar_url } = user
        
        const userLink = document.createElement('a')
        userLink.innerHTML = login
        userLink.href = html_url
        userLink.target = '_blank'

        listItem.append(userLink)

        const userImg = document.createElement('img')
        userImg.src = avatar_url
        userImg.width = 50
        userImg.height = 50
        
        listItem.append(userImg)
        
        list.appendChild(listItem)
    }
}

const buttonSearch = document.getElementById('search')
buttonSearch.addEventListener('click', search)