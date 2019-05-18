$("#modal-window").find(".modal-content").html("<%= j (render 'kennels/modals/edit_kennel_info') %>");
$("#modal-window").modal();