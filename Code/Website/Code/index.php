<?php
  function random_hex_number() { return str_pad( dechex( mt_rand( 0, 255 ) ), 2, '0', STR_PAD_LEFT); }
  
  $image_paths = array(
    "https://kirkja.org/favicon.png",
    "https://cdna.artstation.com/p/assets/images/images/032/449/064/medium/nicola-saviori-dtiys.jpg?1606473190",
    "https://cdnb.artstation.com/p/assets/images/images/032/134/431/medium/nicholas-kole-img-4171.jpg?1605571035");
  
  $sayings = array(
    "Game design methods for modern living.",
    "Believers-in-play, be welcomed!");
    
  $descriptions = array(
    "Kirkja uses the lens of game design to develop and provide unfettered access to lifelong educational tools, techniques, playgrounds, and systems for creating balanced communities of earthling ecosystems.",
    "Leikjatrú (believers-in-play) are dedicated to the belief that failure and iteration are the tools of personal growth.");
   
  $colors = array(
    "4cdc3d", # green
    "c247c1"); # purple
  
  #$random_color = random_hex_number() . random_hex_number() . random_hex_number();
  $random_color = $colors[mt_rand(0, count($colors) - 1)];
  $random_image = $image_paths[mt_rand(0, count($image_paths) - 1)];
  $random_saying = $sayings[mt_rand(0, count($sayings) - 1)];
  #$random_description = $descriptions[mt_rand(0, count($sayings) - 1)];
?>

<!DOCTYPE html> 

<html itemscope itemtype="http://schema.org/ItemList" class="story">
  <head>

    <title>Kirkja</title>

    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8"/>
    <meta id="viewport" name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes, minimum-scale=0.5, maximum-scale=2.0"/>

    <!-- CSS -->
    <link rel="icon" href="favicon.png">
    <link rel="stylesheet" href="default.css" media="all" type="text/css"/>

    <meta name="distribution" content="global"/>
    <meta name="rating" content="general"/>
    <meta name="language" content="en_US"/>
    <meta name="robots" content="index, follow"/>
    
    <!-- DISCORD -->
    <meta name="theme-color" content="<?php echo('#' . $random_color); ?>"/> <!-- Sidebar Color -->
    <meta property="og:locale" content="en_US"/>
    <meta property="og:type" content="article"/>
    <meta property="og:image" itemprop="image" content="https://kirkja.org/discord_embed.png"/> <!-- Thumbnail 80px x 80px. -->
    <meta property="og:site_name" content="kirkja.org | Official Website"/> <!-- The little narrow white text. -->
    <meta property="og:title" content="<?php echo($random_saying); ?>"/> <!-- The bold blue link. -->
    <meta property="og:description" content="<?php echo($descriptions[0]); ?>"/> <!-- The white description. -->
    <meta name="twitter:card" content="summary_large_image"> <!-- Twitter Hack, large image 400px x 130px -->
  
  </head>

  <body>
    <h1>Kirkja</h1>
    <p class="under">Under construction: Pre-Alpha: Bugs and errors abound!</p>
    
    <h2>Kirkja Mission Statement</h2>
    <p>Kirkja uses the lens of game design to develop and provide unfettered access to lifelong educational tools, techniques, playgrounds, and systems for creating balanced communities of earthling ecosystems.</p>  
    
    <h2>Kirkja Programs</h2>
    <p>Kirkja aims to provide several programs that intermingle different disciplines. The various programs fall under two general headings: Online &amp; IRL.</p>
    
    <h3>Kirkja Online: the ones and zeros.</h3>
    <p>Kirkja will build and provide a digital frame the digital interfaces for participants to learn how to play with tools of self expression.</p>
    
    <ul>
      <li>KOR Framework</li>
      <li>Leikskóli</li>
    </ul>

    <h3>Kirkja IRL</h3>
    <p>Kirkja IRL (in real life) is comprised of everything that isn't happening in Kirkja Online. For example, local meet-ups, game jams, concerts, industry talks.</p>
    
    <ul>
      <li>DevKOR.</li>
      <li>Leikskoli Dev.</li>
      <li>Infrastructure.</li>
      <li>Mutual Aid &amp; Open Source Education.</li>
    </ul>

    
    <h2>About</h2>
    
    <h3>Kirkja Board of Directors</h3>
    
    <ul>
      <li>Hailey Maria: <i>(bio inbound)</i>.</li>
      <li>Hope Uselton: <i>(bio inbound)</i>, plus future author of <em><strong>"Video Game Controllers: 1985-2015</strong> The use, history and service guides for first-party controllers of home video game consoles (excluding light guns, mice, keyboards, and steering wheels) from the third generation to the eighth.</em>"</li>
      <li>Kathryn Sullivan: <i>(bio inbound)</i>.</li>
      <li>Kyle Rhône: <i>(bio inbound)</i> his D&amp;D alignment is sometimes <em>too</em> chaotic + good for some adventurers' palette, but he can iterate quickly through any friction that it causes.</li>
      <li>Rob Guinn: <i>(bio inbound)</i> he might have a passport, you can never tell with Rob. ¯\_(ツ)_/¯</li>
    </ul>
    
    <h3>Kirkja Officers</h3>

    <ul>
      <li>President: Kyle Rhône </li>
      <li>Secretary: Kathryn Sullivan</li>
      <li>Treasurer: Rob Guinn</li>
    </ul>
    
    <h2>FAQ</h2>
    <h3>How does one say Kirkja?</h3>
    <p><a href="https://translate.google.com/?hl=en&tab=TT&sl=is&tl=en&text=kirkja&op=translate">just for now</a></p>
    
    
    
    <div id="footer">
      <div id="copyright">
        <p>&copy; <?php echo date('Y'); ?> Kirkja. All rights reserved.</p>
      </div>
    </div>
  </body>
</html>