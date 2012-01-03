$(function() {
  $.support.touch = typeof Touch === 'object';
  if (!$.support.touch) {
    console.log(['no touch']);
    return;
  }
  console.log(['good touch']);


  var lastTouch;
  var DELAY = 750;
  var timeout, shouldTriggerHold = false;

  function handleTouchEvent(e) {
    
    var touches = e.changedTouches;
    var first   = e.touches[0];
    var type = '';
    
    // e.touches[0] is empty on touchend, use the last TouchList object instead
    if (first != undefined) {
      lastTouch = first;
    } else {
      first = lastTouch;
    }
    
    switch (e.type) {
    case 'touchstart':
      type='mousedown';
      // $( document ).trigger($.Event("mouseup")); //reset mouseHandled flag in ui.mouse
      timeout = setTimeout(function(){ if ( first.target ){ $(first.target).trigger('touchhold.start'); }; shouldTriggerHold = true; }, DELAY);
      break;
    case 'touchmove':
      type='mousemove';
      clearTimeout(timeout);
      // KLUDGE: we should be binding with the $ fn business
      if ($(first.target).hasClass('ui-draggable')){ e.preventDefault(); }
      break;
    case 'touchend':
      type='mouseup';
      clearTimeout(timeout);
      if (shouldTriggerHold){ if (first.target){ $(first.target).trigger('touchhold.end'); }; shouldTriggerHold = false };
      break;
    default: return;
    }

    //initMouseEvent(type, canBubble, cancelable, view, clickCount,
    //           screenX, screenY, clientX, clientY, ctrlKey,
    //           altKey, shiftKey, metaKey, button, relatedTarget);
    var se = document.createEvent('MouseEvent');
    se.initMouseEvent(type, true, true, window, 1,
                      first.screenX, first.screenY,
                      first.clientX, first.clientY,
                      false, false, false, false,
                      0/*left*/, null);
    first.target.dispatchEvent(se);
    
    return;
  }
  
  document.documentElement.style.webkitTouchCallout = 'none';
  document.documentElement.addEventListener('touchstart',  handleTouchEvent, true);
  document.documentElement.addEventListener('touchmove',   handleTouchEvent, true);
  document.documentElement.addEventListener('touchend',    handleTouchEvent, true);
  document.documentElement.addEventListener('touchcancel', handleTouchEvent, true);
  
  return;
});
