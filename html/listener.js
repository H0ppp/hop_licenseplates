
$(function() {
    var $container = $("#container");
    var $oldPlate = $("#oldPlate");
    var $newPlate = $("#newPlate");
    $container.hide();


	window.addEventListener('message', function(event){
		var item = event.data;

		if (item.type === "show") {
            $container.show();
            $oldPlate.val(item.currentPlate);
	    } else if (item.type === "valid") {
            Close();
	    } else if (item.type === "notValid") {
            $newPlate.val("");
	    }
    }); 
});

function Submitted() {
    var $newPlate = $("#newPlate");
    fetch(`https://${GetParentResourceName()}/plateRequest`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            itemId: $newPlate.val()
        })
    }).then(resp => resp.json());
}

function Close() {
    var $container = $("#container");
    var $newPlate = $("#newPlate");
    $container.hide();
    $newPlate.val("");
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            itemId: 'close'
        })
    }).then(resp => resp.json());
}