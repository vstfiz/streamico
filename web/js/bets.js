var List = [];
 async function fetchBets(){
    var ref = firebase.firestore();
    await ref.collection('bets').get().then(function (querySnapshot){
        console.log("bets reached");
        querySnapshot.forEach(function(doc){
            console.log(doc.data());
            List.push(doc.data());
        });

    }).catch(function (error){
        alert(error.message);
    });
}

async function runners(){
    await fetchBets();
    console.log(List.length);
    console.log(List[0]['uid']);
}
