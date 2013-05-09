GKFN = {
    feedback_base_url : 'http://geekui.com',
    
    showFeedback : function() {
        var feedback_on_html = document.getElementsByTagName('html')[0];
        var feedback_iframe = document.getElementById('feedback_iframe');
        var feedback_overlay = document.getElementById('feedback_overlay');
        var feedback_container = document.getElementById('feedback_container');
        var feedback_loading = document.getElementById('feedback_loading');
        var feedback_close = document.getElementById('feedback_close');
        feedback_overlay.className = '';
        feedback_loading.className = '';
        feedback_close.className = '';
        feedback_iframe.src = GKFN.feedback_url;
        feedback_on_html.className = feedback_on_html.className + ' feedback_tab_on';
        var container_left = document.documentElement.clientWidth/2 - 338 + 'px';
        feedback_container.style.left = container_left;
        if (feedback_iframe.addEventListener) {
            feedback_iframe.addEventListener('load', GKFN.feedbackLoaded, false);
        } else if (feedback_iframe.attachEvent) {
            feedback_iframe.attachEvent('onload', GKFN.feedbackLoaded);
        }
    },
    hideFeedback : function() {
        var feedback_iframe = document.getElementById('feedback_iframe');
        var feedback_overlay = document.getElementById('feedback_overlay');
        var feedback_on_html = document.getElementsByTagName('html')[0];

        feedback_overlay.className = 'dn';
        feedback_iframe.className = 'dn';
        feedback_iframe.src = GKFN.feedback_base_url + '/static/img/widgets/blank.gif';
        feedback_on_html.className = feedback_on_html.className.replace('feedback_tab_on', '');

        if (feedback_iframe.addEventListener) {
            feedback_iframe.removeEventListener('load', GKFN.feedbackLoaded, false);
        } else if (feedback_iframe.attachEvent) {
            feedback_iframe.detachEvent('onload', GKFN.feedbackLoaded);
        }
    },
    feedbackLoaded : function() {
        document.getElementById('feedback_loading').className="dn";
        document.getElementById('feedback_iframe').className = '';
        document.getElementById('feedback_close').className = 'loaded';
    },
    feedback_widget : function(options) {
        GKFN.options = options;
            if (options.product_sub_url) {
                GKFN.feedback_url = GKFN.feedback_base_url + '/widget/feedback?company_sub_url=' + GKFN.options.company_sub_url + '&product_sub_url=' + GKFN.options.product_sub_url + '&display=' + GKFN.options.display;
            } else {
                GKFN.feedback_url = GKFN.feedback_base_url + '/widget/feedback?company_sub_url=' + GKFN.options.company_sub_url + '&display=' + GKFN.options.display;
            }

            GKFN.addCSSFile();
            GKFN.iframe_html = '<iframe id="feedback_iframe" allowTransparency="true" scrolling="no" frameborder="0" class="dn" src="'+GKFN.feedback_base_url + '/static/img/widgets/blank.gif"></iframe>';
         
            var container_left = document.documentElement.clientWidth/2 - 338 + 'px';
            GKFN.overlay_html = '<div id="feedback_overlay" class="dn"><div id="feedback_container" style="left: ' + container_left + ' "><a href="javascript:void(0)" id="feedback_close"></a><div id="feedback_loading" class="dn"><p class="t-c" style="position:absolute;top:130px;left:170px"></p><img src="' + GKFN.feedback_base_url + '/static/img/widgets/ajax-loader.gif" /></div>' + GKFN.iframe_html + '</div><div id="feedback_screen"></div></div>';

            document.write(GKFN.overlay_html);

            var feedback_obj = GKFN;
            $('#feedback').live("click", function() {
                feedback_obj.showFeedback();
                return false;
            });
            $('#feedback_close').live("click" ,function() {
                feedback_obj.hideFeedback();
                return false;
            });
    },
    addCSSFile : function() {
        var head = document.getElementsByTagName('head')[0];
        var style = document.createElement('link');
        style.rel = 'stylesheet';
        style.type = 'text/css';
        style.href = GKFN.feedback_base_url +'/static/css/feedback_widgets-1.0.1.3.css';
        head.appendChild(style);
    }
   
};
 new GKFN.feedback_widget({product_sub_url : "yicheng-checkon",
 company_sub_url : "byronlee",
 display : "overlay"});

