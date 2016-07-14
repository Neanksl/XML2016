<?xml version="1.0"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:output
        method="html"
        indent="yes"
        standalone="no"
        doctype-public="-//W3C//DTD SVG 1.1//EN"
        doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
        media-type="image/svg"/>
    
    <!-- This XSLT uses two XML sources, where Static.xml is declared as a main XML -->
    <xsl:variable name="GameState" select="document('http://localhost:8984/gamestate')"/>

    <xsl:template match="static">
        <svg width="{board/width}" height="{board/height}">
            <!-- Create graphics templates -->
            <defs>
                <rect
                    id="houseThisPlayerTemplate"
                    width="{house/width}" height="{house/height}"
                    rx="{house/roundX}"	ry="{house/roundY}"
                    style="{house/styleThisPlayer}"/>
                
                <rect
                    id="houseOtherPlayerTemplate"
                    width="{house/width}" height="{house/height}"
                    rx="{house/roundX}"	ry="{house/roundY}"
                    style="{house/styleOtherPlayer}"/>
							
                <circle
                    id="seedTemplate"
                    r="{((house/width + house/height) div 2) div 12}"
                    style="{seed/style}"/>

                <circle
                    id="storeThisPlayerTemplate"
                    r="{store/radius}"
                    cx="{store/radius}"
                    style="{store/styleThisPlayer}"/>
                
                <circle
                    id="storeOtherPlayerTemplate"
                    r="{store/radius}"
                    cx="{store/radius}"
                    style="{store/styleOtherPlayer}"/>
                
                <polygon 
                    id="triangleTopTemplate"
                    points="0,0 {0.3*store/radius},0 {0.5*0.3*store/radius},{0.9*0.3*store/radius}" 
                    style="{board/trianglestyleThisPlayer}">
                    <animate
                        attributeType="XML"
                        attributeName="fill"
                        values="{board/triangleAnimateThisPlayer}"
                        dur="2s"
                        repeatCount="indefinite"/>
                </polygon>
                
                <polygon
                    id="triangleBotTemplate"
                    points="0,{0.9*0.3*store/radius} {0.3*store/radius},{0.9*0.3*store/radius} {0.5*0.3*store/radius},0" 
                    style="{board/trianglestyleThisPlayer}">
                    <animate
                        attributeType="XML"
                        attributeName="fill"
                        values="{board/triangleAnimateThisPlayer}"
                        dur="2s"
                        repeatCount="indefinite"/>
                </polygon>
                
                <polygon 
                    id="triangleLeftTemplate"
                    points="0,{0.15*store/radius} 0,{-0.15*store/radius} {-0.9*0.3*store/radius},0" 
                    style="{board/trianglestyleWinner}">
                    <animate
                        attributeType="XML"
                        attributeName="fill"
                        values="{board/triangleAnimateWinner}"
                        dur="1s"
                        repeatCount="indefinite"/>
                </polygon>
                
                <polygon 
                    id="triangleRightTemplate"
                    points="0,{0.15*store/radius} 0,{-0.15*store/radius} {0.9*0.3*store/radius},0" 
                    style="{board/trianglestyleWinner}">
                    <animate
                        attributeType="XML"
                        attributeName="fill"
                        values="{board/triangleAnimateWinner}"
                        dur="1s"
                        repeatCount="indefinite"/>
                </polygon>
            </defs>
            
            <!-- Create background frame -->
            <rect
                x="{layout/posStartX - layout/distanceHouseStore + layout/distanceHorizontalHouse}" 
                y="{layout/posStartY - layout/distanceVerticalHouseFrame}"
                id="backgroundFrame"
                width="{house/nrOfHouses * (house/width + layout/distanceHorizontalHouse) - layout/distanceHorizontalHouse
                    + 2 * (layout/distanceHouseStore + store/radius)}" 
                height="{2 * (house/height  + layout/distanceVerticalHouseFrame) + layout/distanceVertitalHouse}"
                rx="{layout/backgroundFrame/roundX}" 
                ry="{layout/backgroundFrame/roundY}"
                style="{layout/backgroundFrame/style}"/>
            
            <!-- Create menu buttons -->
            <!-- Try again button -->
            <a href="tryagain">
                <rect
                    x="{layout/posStartX + house/width + layout/distanceHorizontalHouse}" 
                    y="{layout/posStartY - 2 * layout/distanceVerticalHouseFrame - 0.5 * house/height}"
                    id="tryAgainButton"
                    width="{house/width}" 
                    height="{0.5 * house/height}"
                    rx="{house/roundX}" 
                    ry="{house/roundY}"
                    style="{menu/tryAgainButton/style}"/>					
                <text
                    x="{layout/posStartX + house/width + layout/distanceHorizontalHouse + 0.5 * house/width}"
                    y="{layout/posStartY - 2 * layout/distanceVerticalHouseFrame + (- 0.5 + 0.3)* house/height}"
                    text-anchor="middle"
                    font-size="{0.2 * house/width}"
                    style="{menu/tryAgainButton/textstyle}">
                    <xsl:value-of select="menu/tryAgainButton/desc"/>
                </text>
            </a>      
            
            <!-- Start over button -->
            <a href="db/create">
                <rect
                    x="{layout/posStartX + 2 * (house/width + layout/distanceHorizontalHouse)}" 
                    y="{layout/posStartY - 2 * layout/distanceVerticalHouseFrame - 0.5 * house/height}"
                    id="startOverButton"
                    width="{house/width}" 
                    height="{0.5 * house/height}"
                    rx="{house/roundX}" 
                    ry="{house/roundY}"
                    style="{menu/startOverButton/style}"/>					
                <text
                    x="{layout/posStartX + 2 * (house/width + layout/distanceHorizontalHouse) + 0.5 * house/width}"
                    y="{layout/posStartY - 2 * layout/distanceVerticalHouseFrame + (- 0.5 + 0.3)* house/height}"
                    text-anchor="middle"
                    font-size="{0.2 * house/width}"
                    style="{menu/startOverButton/textstyle}">
                    <xsl:value-of select="menu/startOverButton/desc"/>
                </text>
            </a>
            
            <!-- High score button -->
            <a href="">
                <rect
                    x="{layout/posStartX + 5 * (house/width + layout/distanceHorizontalHouse)}" 
                    y="{layout/posStartY - 2 * layout/distanceVerticalHouseFrame - 0.5 * house/height}"
                    id="startOverButton"
                    width="{2 * house/width}" 
                    height="{0.5 * house/height}"
                    rx="{house/roundX}" 
                    ry="{house/roundY}"
                    style="{menu/highscoreButton/style}"/>					
                <text
                    x="{layout/posStartX + 5 * (house/width + layout/distanceHorizontalHouse) + house/width}"
                    y="{layout/posStartY - 2 * layout/distanceVerticalHouseFrame + (- 0.5 + 0.3)* house/height}"
                    text-anchor="middle"
                    font-size="{0.2 * house/width}"
                    style="{menu/highscoreButton/textstyle}">
                    <xsl:value-of select="concat(menu/highscoreButton/desc, ' ', $GameState/game/players/highestScore)"/>
                </text>
            </a>
            
            <!--
            <xsl:for-each select="menu/button">
                <a href="{self::node()/link}">
                    <rect
                        x="{self::node()/posX}" 
                        y="{self::node()/posY}"
                        id="{self::node()/id}"
                        width="{self::node()/width}" height="{self::node()/height}"
                        rx="{self::node()/roundX}" ry="{self::node()/roundY}"
                        style="{self::node()/style}"/>
					
                    <text
                        x="{self::node()/posX + 0.5 * self::node()/width}"
                        y="{self::node()/posY + 0.6 * self::node()/height}"
                        text-anchor="middle"
                        font-size="{0.2 * self::node()/width}"
                        style="{self::node()/textstyle}">
                        <xsl:value-of select="self::node()/desc"/>
                    </text>
                </a>
            </xsl:for-each>  
            
            <xsl:for-each select="menu/display">
                <rect
                    x="{self::node()/posX}" 
                    y="{self::node()/posY}"
                    id="{self::node()/id}"
                    width="{self::node()/width}" height="{self::node()/height}"
                    rx="{self::node()/roundX}" ry="{self::node()/roundY}"
                    style="{self::node()/style}"/>
					
                <text
                    x="{self::node()/posX + 0.5 * self::node()/width}"
                    y="{self::node()/posY + 0.6 * self::node()/height}"
                    text-anchor="middle"
                    font-size="{0.2 * self::node()/width}"
                    style="{self::node()/textstyle}">
                    <xsl:value-of select="concat(self::node()/desc, ' ', $GameState/game/players/highestScore)"/>
                </text>
            </xsl:for-each>    
            -->
            
            
            <!-- Create houses for both players -->
            <xsl:call-template name="createHouses">
                <xsl:with-param name="count" select="house/nrOfHouses"/>
            </xsl:call-template>
					
            <!-- Create stores for both players -->
            <!-- Top = Player 1, Bot = Player 2 -->
            <xsl:choose>
                <xsl:when test="$GameState/game/players/turn = '1'">
                    <!-- Player 1, Top Store -->
                    <g>                        
                        <use 
                            x="{layout/posStartX - layout/distanceHouseStore - store/radius + layout/distanceHorizontalHouse}" 
                            y="{layout/posStartY + house/height + (layout/distanceVertitalHouse div 2)}"
                            xlink:href="#storeThisPlayerTemplate"/>
                        <text
                            x="{layout/posStartX - layout/distanceHouseStore + layout/distanceHorizontalHouse}"
                            y="{layout/posStartY + house/height + (layout/distanceVertitalHouse div 2) + 0.35 * store/radius}"
                            text-anchor="middle"
                            font-size="{store/radius}"
                            style="{store/textstyleThisPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[1]/store"/>
                        </text>
                    </g>
                    
                    <!-- Player 1, Bot Store -->
                    <g>
                        <use				
                            x="{layout/posStartX + layout/distanceHouseStore + (house/width + layout/distanceHorizontalHouse) * house/nrOfHouses + store/radius}"
                            y="{layout/posStartY + house/height + (layout/distanceVertitalHouse div 2)}" 
                            xlink:href="#storeOtherPlayerTemplate"/>
                        <text
                            x="{layout/posStartX + layout/distanceHouseStore + (house/width + layout/distanceHorizontalHouse) * house/nrOfHouses + 2 * store/radius}"
                            y="{layout/posStartY + house/height + (layout/distanceVertitalHouse div 2) + 0.35 * store/radius}"
                            text-anchor="middle"
                            font-size="{store/radius}"
                            style="{store/textstyleOtherPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[2]/store"/>
                        </text>
                    </g>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Player 2, Top Store -->
                    <g>                        
                        <use 
                            x="{layout/posStartX - layout/distanceHouseStore - store/radius + layout/distanceHorizontalHouse}" 
                            y="{layout/posStartY + house/height + (layout/distanceVertitalHouse div 2)}"
                            xlink:href="#storeOtherPlayerTemplate"/>
                        <text
                            x="{layout/posStartX - layout/distanceHouseStore + layout/distanceHorizontalHouse}"
                            y="{layout/posStartY + house/height + (layout/distanceVertitalHouse div 2) + 0.35 * store/radius}"
                            text-anchor="middle"
                            font-size="{store/radius}"
                            style="{store/textstyleOtherPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[1]/store"/>
                        </text>
                    </g>
                    
                    <!-- Player 2, Bot Store -->
                    <g>
                        <use
                            x="{layout/posStartX + layout/distanceHouseStore + (house/width + layout/distanceHorizontalHouse) * house/nrOfHouses + store/radius}"
                            y="{layout/posStartY + house/height + (layout/distanceVertitalHouse div 2)}" 
                            xlink:href="#storeThisPlayerTemplate"/>
                        <text
                            x="{layout/posStartX + layout/distanceHouseStore + (house/width + layout/distanceHorizontalHouse) * house/nrOfHouses + 2 * store/radius}"
                            y="{layout/posStartY + house/height + (layout/distanceVertitalHouse div 2) + 0.35 * store/radius}"
                            text-anchor="middle"
                            font-size="{store/radius}"
                            style="{store/textstyleThisPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[2]/store"/>
                        </text>
                    </g>
                </xsl:otherwise>
            </xsl:choose>
                    
            <!-- Display game info: game over or player's turn -->
            <xsl:choose>
                <xsl:when test="not($GameState/game/wonBy = '0')">
                    <!-- Game is over -->
                    <text
                        x="{layout/posStartX + 4 * house/width + 3.5 * layout/distanceHorizontalHouse}"
                        y="{layout/posStartY + house/height + 0.7 * layout/distanceVertitalHouse}"
                        text-anchor="middle"
                        font-size="{0.5 * house/width}"
                        style="{menu/gameOver/textstyle}">
                        <xsl:value-of select="concat('Player ', $GameState/game/wonBy, ' won!')"/>
                    </text>
                    <xsl:choose>
                        <!-- Display blinking triangle indicating winner's side -->
                        <xsl:when test="$GameState/game/wonBy = '1'">
                            <use 
                                x="{layout/posStartX + 3 * house/width + 2 * layout/distanceHorizontalHouse}" 
                                y="{layout/posStartY + house/height + 0.5 * layout/distanceVertitalHouse}" 
                                xlink:href="#triangleLeftTemplate"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <use 
                                x="{layout/posStartX + 5 * house/width + 5 * layout/distanceHorizontalHouse}" 
                                y="{layout/posStartY + house/height + 0.5 * layout/distanceVertitalHouse}" 
                                xlink:href="#triangleRightTemplate"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>	
                    <!-- Current player's turn -->
                    <text
                        x="{layout/posStartX + 4 * house/width + 3.5 * layout/distanceHorizontalHouse}"
                        y="{layout/posStartY + house/height + 0.7 * layout/distanceVertitalHouse}"
                        text-anchor="middle"
                        font-size="{0.5 * house/width}"
                        style="{menu/gameTurn/textstyle}">
                        <xsl:value-of select='concat("Player ", $GameState/game/players/turn, "&apos;", "s turn...")'/>
                    </text>
                    <xsl:choose>
                        <!-- Display blinking triangle indicating current player's turn -->
                        <xsl:when test="$GameState/game/players/turn = '1'">
                            <use 
                                x="{layout/posStartX - layout/distanceHouseStore + layout/distanceHorizontalHouse - 0.5 * 0.3 * store/radius}" 
                                y="{layout/posStartY + house/height + (layout/distanceVertitalHouse div 2) + (0.35 - 1.25) * store/radius}" 
                                xlink:href="#triangleTopTemplate"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <use 
                                x="{layout/posStartX + layout/distanceHouseStore + (house/width + layout/distanceHorizontalHouse) * house/nrOfHouses + 2 * store/radius - 0.5 * 0.3 * store/radius}" 
                                y="{layout/posStartY + house/height + (layout/distanceVertitalHouse div 2) + (0.35 + 0.3) * store/radius}" 
                                xlink:href="#triangleBotTemplate"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </svg>
    </xsl:template>
	
    <!-- Recursion -->
    <xsl:template name="createHouses"> 
        <xsl:param name="count"/>
        <xsl:if test="$count &gt; 0">
            <xsl:choose>
                <xsl:when test="$GameState/game/players/turn = '1'">
                    <!-- Player 1, Upper houses -->
                    <g>
                        <xsl:choose>
                            <xsl:when test="$GameState/game/board/layer[1]/house[7 - $count] = 0">
                                <use 
                                    x="{layout/posStartX + (house/width + layout/distanceHorizontalHouse) * $count}" 
                                    y="{layout/posStartY}"
                                    xlink:href="#houseThisPlayerTemplate"/>					
                                <text
                                    x="{layout/posStartX + (house/width + layout/distanceHorizontalHouse) * $count + 0.5 * house/width}"
                                    y="{layout/posStartY + 0.6 * house/height}"
                                    text-anchor="middle"
                                    font-size="{0.3 * house/width}"
                                    style="{house/textstyleThisPlayer}">
                                    <xsl:value-of select="$GameState/game/board/layer[1]/house[7 - $count]"/>
                                </text>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="clicked/{7 - $count}" >
                                    <use 
                                        x="{layout/posStartX + (house/width + layout/distanceHorizontalHouse) * $count}" 
                                        y="{layout/posStartY}"
                                        xlink:href="#houseThisPlayerTemplate"/>					
                                    <text
                                        x="{layout/posStartX + (house/width + layout/distanceHorizontalHouse) * $count + 0.5 * house/width}"
                                        y="{layout/posStartY + 0.6 * house/height}"
                                        text-anchor="middle"
                                        font-size="{0.3 * house/width}"
                                        style="{house/textstyleThisPlayer}">
                                        <xsl:value-of select="$GameState/game/board/layer[1]/house[7 - $count]"/>
                                    </text>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </g>			
				
                    <!-- Player 1, Bottom houses -->
                    <g>
                        <use 
                            x="{layout/posStartX + (house/width + layout/distanceHorizontalHouse) * $count}" 
                            y="{layout/posStartY + house/height + layout/distanceVertitalHouse}" 
                            xlink:href="#houseOtherPlayerTemplate"/>
                        <text
                            x="{layout/posStartX + (house/width + layout/distanceHorizontalHouse) * $count + 0.5 * house/width}"
                            y="{layout/posStartY + house/height + layout/distanceVertitalHouse + 0.6 * house/height}"
                            text-anchor="middle"
                            font-size="{0.3 * house/width}"
                            style="{house/textstyleOtherPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[2]/house[0 + $count]"/>
                        </text>
                    </g>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Player 2, Upper houses -->
                    <g>
                        <use 
                            x="{layout/posStartX + (house/width + layout/distanceHorizontalHouse) * $count}" 
                            y="{layout/posStartY}"
                            xlink:href="#houseOtherPlayerTemplate"/>					
                        <text
                            x="{layout/posStartX + (house/width + layout/distanceHorizontalHouse) * $count + 0.5 * house/width}"
                            y="{layout/posStartY + 0.6 * house/height}"
                            text-anchor="middle"
                            font-size="{0.3 * house/width}"
                            style="{house/textstyleOtherPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[1]/house[7 - $count]"/>
                        </text>
                    </g>			
				
                    <!-- Player 2, Bottom houses -->
                    <g>
                        <xsl:choose>
                            <xsl:when test="$GameState/game/board/layer[2]/house[0 + $count] = 0">
                                <use 
                                    x="{layout/posStartX + (house/width + layout/distanceHorizontalHouse) * $count}" 
                                    y="{layout/posStartY + house/height + layout/distanceVertitalHouse}" 
                                    xlink:href="#houseThisPlayerTemplate"/>
                                <text
                                    x="{layout/posStartX + (house/width + layout/distanceHorizontalHouse) * $count + 0.5 * house/width}"
                                    y="{layout/posStartY + house/height + layout/distanceVertitalHouse + 0.6 * house/height}"
                                    text-anchor="middle"
                                    font-size="{0.3 * house/width}"
                                    style="{house/textstyleThisPlayer}">
                                    <xsl:value-of select="$GameState/game/board/layer[2]/house[0 + $count]"/>
                                </text>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="clicked/{$count + 7}" >
                                    <use 
                                        x="{layout/posStartX + (house/width + layout/distanceHorizontalHouse) * $count}" 
                                        y="{layout/posStartY + house/height + layout/distanceVertitalHouse}" 
                                        xlink:href="#houseThisPlayerTemplate"/>
                                    <text
                                        x="{layout/posStartX + (house/width + layout/distanceHorizontalHouse) * $count + 0.5 * house/width}"
                                        y="{layout/posStartY + house/height + layout/distanceVertitalHouse + 0.6 * house/height}"
                                        text-anchor="middle"
                                        font-size="{0.3 * house/width}"
                                        style="{house/textstyleThisPlayer}">
                                        <xsl:value-of select="$GameState/game/board/layer[2]/house[0 + $count]"/>
                                    </text>
                                </a>
                            </xsl:otherwise>   
                        </xsl:choose>                         
                    </g>
                </xsl:otherwise>
            </xsl:choose>            			
				
            <xsl:call-template name="createHouses">
                <xsl:with-param name="count" select="$count - 1"/>
            </xsl:call-template>
        </xsl:if>      
    </xsl:template>
</xsl:stylesheet>
