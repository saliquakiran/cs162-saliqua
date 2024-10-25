Chrome Developer Tools

How BBC uses Divs?
1. Overall Container: The entire page is housed within a main <div>, which acts as a container for everything else.
2. Header, Main Content, Footer: Inside this main container, there are separate <div>s for the header (containing the BBC logo, navigation, etc.), the main content area, and the footer.
3. Sections within Sections: The main content area is further divided into <div>s. For example, there's a <div> for top headlines, another for "More on this story," and so on. This nesting of <div>s within <div>s continues for several levels, creating a clear hierarchy.

A typical Div Structure

<div id="container"> 
    <div id="header"> 
        </div>

    <div id="main-content"> 
        <div class="news-section"> </div>
        <div class="news-section"> </div>
    </div> 

    <div id="footer"> 
        </div>
</div> 

1. Outermost Div (#container): This acts as a wrapper for the entire page's content.
2. Header, Main, Footer: Three main <div>s (#header, #main-content, #footer) divide the page into logical sections.
3. Sections within #main-content: Two <div>s with the class "news-section" demonstrate how content is further organized within the main content area. You could have multiple divs with this class for different news sections.
By nesting <div>s in this way, one can create a clear and organized structure for the website.