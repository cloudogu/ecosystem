var baseUrl = '';

var head = document.getElementsByTagName('head')[0];
var body = document.getElementsByTagName('body')[0];

var lss = isLocalStorageSupported();

// create link
function createLink(href){
  if (href.indexOf('http') === 0){
    return href;
  } else {
    return baseUrl + href;
  }
}

// http://stackoverflow.com/questions/11214404/how-to-detect-if-browser-supports-html5-local-storage
function isLocalStorageSupported(){
  var mod = '__warp';
  try {
    localStorage.setItem(mod, mod);
    localStorage.removeItem(mod);
    return true;
  } catch(e){
    return false;
  }
}

function getCategoryKey(category){
  return "warpc." + category.Title.toLowerCase().replace(/\s+/g, "_");
}

function toggleCategory(e){
  var target = e.target;
  if (target && target.rel){
    toggleClass(target, 'warpmenu-category-open');
    var el = document.getElementById(target.rel);
    if (el){
      if (hasClass(el, 'warpmenu-collapsed')){
        if (lss){
          localStorage.removeItem(target.rel + '.collapsed');
        }
        removeClass(el, 'warpmenu-collapsed');
      } else {
        if (lss){
          localStorage.setItem(target.rel + '.collapsed', true);
        }
        addClass(el, 'warpmenu-collapsed');
      }
    }
  }
}

function initWarpMenu(categories){
  addClass(body, 'warpmenu-push');

  // create html
  var nav = document.createElement('nav');
  nav.className = "warpmenu warpmenu-vertical warpmenu-right";
  nav.id = "warpmenu-s1";
  body.appendChild(nav);

  var home = document.createElement('div');
  addClass(home, 'warpmenu-home');
  var homeLink = document.createElement('a');
  homeLink.target = '_top';
  homeLink.href = createLink('/');
  var logo = document.createElement('div');
  addClass(logo, 'warpmenu-logo');
  homeLink.appendChild(logo);
  home.appendChild(homeLink);
  nav.appendChild(home);

  for (var c=0; c<categories.length; c++){
    var category = categories[c];
    var id = getCategoryKey(category);
    var ul = document.createElement('ul');
    ul.id = id;
    var collapsed = false;
    if (lss){
      collapsed = localStorage.getItem(id + '.collapsed');
    }
    if (collapsed){
      addClass(ul, 'warpmenu-collapsed');
    }
    for (var i=0; i<category.Entries.length; i++){
      var link = category.Entries[i];
      var li = document.createElement('li');
      var a = document.createElement('a');
      if (link.target){
        a.target = link.target;
      } else {
        a.target = '_top';
      }
      a.href = createLink(link.Href);
      a.innerHTML = link.DisplayName;
      addClass(li, 'warpmenu-link');
      if (i === 0){
        addClass(li, 'warpmenu-link-top');
      }
      li.appendChild(a);
      ul.appendChild(li);
    }

    var h3 = document.createElement('h3');
    h3.rel = id;
    addClass(h3, 'warpbtn-link');
    if (collapsed){
      addClass(h3, 'warpmenu-category-open');
    }
    h3.onclick = toggleCategory;
    h3.innerHTML = category.Title;
    nav.appendChild(h3);

    nav.appendChild(ul);
  }

  var div = document.createElement('div');
  addClass(div, 'warpbtn');
  var btn = document.createElement('a');
  addClass(btn, 'warpbtn-link');

  function toggleNav(){
    toggleClass(div, 'warpbtn-open');
    toggleClass(nav, 'warpmenu-open');
    toggleClass(body,'warpmenu-push-toleft');
  }

  div.onclick = toggleNav;
  div.appendChild(btn);

  // hide menu
  document.onclick = function(e){
    if (e && e.target){
      var target = e.target;
	    // TODO define marker class to stop menu from collapsing
      if (hasClass(nav, 'warpmenu-open') && ! hasClass(target, 'warpbtn-link') && ! hasClass(target, 'warpmenu') && ! hasClass(target, 'warpmenu-home')){
        toggleNav();
      }
    }
  };

  body.appendChild(div);
}

var asyncCounter=0;
var model;

function loaded(menu){
  if (menu){
    model = menu;
  }
  --asyncCounter;
  if (asyncCounter === 0){
    initWarpMenu(model);
  }
}

if (!hasClass(body, 'warpmenu-push') && (self === top || window.pmaversion)){

  // load css
  asyncCounter++;
  addStylesheet('/warp/warp.css', function(success){
    if (success){
      loaded();
    }
  });

  // load model
  asyncCounter++;
  ajax('/warp/menu.json', loaded);
}
