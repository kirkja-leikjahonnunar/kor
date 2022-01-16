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
    <p>
      Krikja believes in the power of gameplay as a method of building one's resiliance.
      Our games and playgrounds aim to bridge the divide between online and irl play.
      We blur the lines between computer and human interaction.
      Individual and group dynamics thrive in settings tailored for digital and unplugged play.
    </p>
    <p>
      Kirkja uses the lens of game design to develop and provide unfettered access to
      lifelong educational tools, techniques, playgrounds, and systems for
      creating balanced communities of earthling ecosystems.
    </p>
    <p>
      We have inherited the systems built by our ancestors without much say in
      the way they've been implemented. Entertainment and amusement are lacking
      in most day to day tasks. Play is a way to build resiliance. By playing
      with the pieces

      As one learns to create words of their own, we create rules and strategies
      Giving the power to create worlds of our own making.
      The digital playground
    </p>
    <p>
      Game design is a type of systems design.
      We find that understanding game design and user experience methods help us
      build worlds for ourselves.
      A weaving of people and their knowledge into an intergenerational and intersectional knowlege base.
      Access to the knowledge base will be first introduced through rural and low income communities.
    </p>

    <p>
      Kirkja is split into two overlapping fields: Kirkja Online and Kirkja IRL.

      Kirkja IRL focuses on the everyday operations of Kirkja programs and goals.

      Kirkja Online is a digital platform that uses game tech to demonstrate the core principals of game development and human education.
      The purpose of KO is to help participants instil efficient training regiments and managable dev habits.
      Our goal is to build a new model for the next evolution of educational institutions.
      It includes a mix of the digital world  and IRL interactions.
      We are essentially making a game that will guide players through the process
      of how to become a developer who is able to make a game of their own.
      Through the process of game creation students of Leikskoli will encounter
      and incorporate valuble industrial level skills,
      as well a the life balance to perform profitable tacks.
    </p>

    <h2>Our Programs</h2>

    <p>
      Kirkja Tinker apprentaship program.
    </p>

    <p>
      Kirkja will build and provide a digital frame the digital interfaces for
      participants to learn how to play with tools of self expression.
    </p>

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


    <h2>Kirkja Ops</h2>

    <h3>Officers</h3>
    Kirkja officers are individuals apointed by the Kirkja board of directors to
    perform the operations of all programs under the oversight of the board.

    <ul>
      <li>
        <b>President:</b> Kyle Rhône </br>
        The post of President is tasked with finding a range of solutions for operational issues.
        The post orchistrates the pieces in one's; encouraging others to dothe same.
      </li>
      <li>
        <b>Secretary:</b> Kathryn Sullivan </br>
      </li>
      <li>
        <b>Treasurer:</b> Rob Guinn </br>

      </li>
    </ul>

    <h3>Board of Directors</h3>
    <p>
      The Kirkja board of directors are charged with maintaining the oversight of
      opperations, ect.
    </p>

    <ul>
      <li>Hailey Maria:
      <li>Hope Uselton:
      <li>Kathryn Sullivan:
      <li>Kyle Rhône: Dedicated. Caring. Leikjatrú.
      <li>Rob Guinn:
    </ul>


    <h2>FAQ</h2>
    Who do I contact for more information about opperations?
    How does one pronounce Kirkja?

    <h3>How does one say Kirkja?</h3>
    <p><a href="https://translate.google.com/?hl=en&tab=TT&sl=is&tl=en&text=kirkja&op=translate">just for now</a></p>



    <div id="footer">
      <div id="copyright">
        <p>&copy; <?php echo date('Y'); ?> Kirkja. All rights reserved.</p>
      </div>
    </div>
  </body>
</html>
