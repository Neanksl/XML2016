<?xml version="1.0"?>
<xsl:stylesheet 
    version="2.0" 
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
        <svg width="{canvas/width}" height="{canvas/height}">
            <defs>
                <g id="houseThisPlayerTemplate">
                    <g id="houseBasic">
                        <path 
                            id="houseBasicEdge"
                            d="{house/basicCircle/edge/direction}"
                            style="{house/basicCircle/edge/style}" />
                        <path 
                            id="houseBasicFill"
                            d="{house/basicCircle/inside/direction}"
                            style="{house/basicCircle/inside/style}" />
                    </g>
                    <path
                        id="shadowHouse"
                        d="{house/shadow/direction}"
                        style="{house/shadow/style}" />
                    <path
                        id="houseInnerSide"
                        d="{house/innerSide/direction}"
                        style="{house/innerSide/style}" />
                    <g id="dashes">
                        <circle 
                            id="outerCircle"
                            cx="{house/dashes/positionX}" 
                            cy="{house/dashes/positionY}"
                            r="{house/dashes/outerRadius}"
                            style="{house/dashes/styleLight}" />
                        <circle 
                            id="middleCircle"
                            cx="{house/dashes/positionX}" 
                            cy="{house/dashes/positionY}"
                            r="{house/dashes/middleRadius}"
                            style="{house/dashes/styleDark}" />
                        <circle 
                            id="innerCircle"
                            cx="{house/dashes/positionX}" 
                            cy="{house/dashes/positionY}"
                            r="{house/dashes/innerRadius}"
                            style="{house/dashes/styleLight}" />
                    </g>                   
                </g>
                <g id="houseOtherPlayerTemplate">
                    <g id="houseBasic">
                        <path 
                            id="houseBasicEdge"
                            d="{house/basicCircle/edge/direction}"
                            style="{house/basicCircle/edge/style}" />
                        <path 
                            id="houseBasicFill"
                            d="{house/basicCircle/inside/direction}"
                            style="{house/basicCircle/inside/style}" />
                    </g>
                    <path
                        id="shadowHouse"
                        d="{house/shadow/direction}"
                        style="{house/shadow/style}" />
                    <path
                        id="houseInnerSide"
                        d="{house/innerSide/direction}"
                        style="{house/innerSide/style}" />
                    <g id="dashes">
                        <circle 
                            id="outerCircle"
                            cx="{house/dashes/positionX}" 
                            cy="{house/dashes/positionY}"
                            r="{house/dashes/outerRadius}"
                            style="{house/dashes/styleLight}" />
                        <circle 
                            id="middleCircle"
                            cx="{house/dashes/positionX}" 
                            cy="{house/dashes/positionY}"
                            r="{house/dashes/middleRadius}"
                            style="{house/dashes/styleDark}" />
                        <circle 
                            id="innerCircle"
                            cx="{house/dashes/positionX}" 
                            cy="{house/dashes/positionY}"
                            r="{house/dashes/innerRadius}"
                            style="{house/dashes/styleLight}" />
                    </g>                   
                </g>
                <g id="storeThisPlayerTemplate">
                    <g id="storeBasic">
                        <circle id="one" cx="{stock/basicCircle/posX}" cy="{stock/basicCircle/posY}" r="{stock/basicCircle/radiusOne}" style="{stock/basicCircle/style}" />
                        <circle id="two" cx="{stock/basicCircle/posX}" cy="{stock/basicCircle/posY}" r="{stock/basicCircle/radiusTwo}" style="{stock/basicCircle/style}" />
                        <circle id="three" cx="{stock/basicCircle/posX}" cy="{stock/basicCircle/posY}" r="{stock/basicCircle/radiusThree}" style="{stock/basicCircle/style}" />                    
                    </g>                
                    <path
                        id="shadowStore"
                        d="{stock/shadow/direction}"
                        style="{stock/shadow/style}" />
                    <path
                        id="storeInnerSide"
                        d="{stock/innerSide/direction}"
                        style="{stock/innerSide/style}" />
                        
                </g>   
                <g id="storeOtherPlayerTemplate">
                    <g id="storeBasic">
                        <circle id="one" cx="{stock/basicCircle/posX}" cy="{stock/basicCircle/posY}" r="{stock/basicCircle/radiusOne}" style="{stock/basicCircle/style}" />
                        <circle id="two" cx="{stock/basicCircle/posX}" cy="{stock/basicCircle/posY}" r="{stock/basicCircle/radiusTwo}" style="{stock/basicCircle/style}" />
                        <circle id="three" cx="{stock/basicCircle/posX}" cy="{stock/basicCircle/posY}" r="{stock/basicCircle/radiusThree}" style="{stock/basicCircle/style}" />                    
                    </g>                
                    <path
                        id="shadowStore"
                        d="{stock/shadow/direction}"
                        style="{stock/shadow/style}" />
                    <path
                        id="storeInnerSide"
                        d="{stock/innerSide/direction}"
                        style="{stock/innerSide/style}" />
                    
                </g> 
                
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
            
            
            <!-- Create menu buttons -->
            <!-- Try again button -->
            <a href="tryagain">
                <rect
                    x="{(board/width div 2) - board/start - (buttons/distance div 2)}"
                    y="{board/start * 0.5}"
                    id="tryAgainButton"
                    width="{buttons/width}" 
                    height="{buttons/height}"
                    rx="{buttons/roundUP}" 
                    ry="{buttons/roundUp}"
                    style="{buttons/style}"/>					
                <text
                    x="{((board/width div 2) - board/start) + (buttons/width div 2) - (buttons/distance div 2)}"
                    y="{(board/start * 0.5) + (buttons/height * 0.7)}"
                    text-anchor="middle"
                    style="{buttons/textStyle}">
                    <xsl:value-of select="menu/tryAgainButton/desc"/>Try Again
                </text>
             </a>      
            
            <!-- Start over button -->
            <a href="db/create">
                <rect
                    x="{(board/width div 2) - board/start + buttons/distance + buttons/width - (buttons/distance div 2)}"
                    y="{board/start * 0.5}"
                    id="startOverButton"
                    width="{buttons/width}" 
                    height="{buttons/height}"
                    rx="{buttons/roundUP}" 
                    ry="{buttons/roundUp}"
                    style="{buttons/style}"/>				
                <text
                    x="{(board/width div 2) - board/start + buttons/distance + buttons/width * 1.5 - (buttons/distance div 2)}"
                    y="{(board/start * 0.5) + (buttons/height * 0.7)}"
                    text-anchor="middle"
                    font-size="{0.2 * house/width}"
                    style="{buttons/textStyle}">Start Over
                    <xsl:value-of select="menu/startOverButton/desc"/>
                </text>
            </a>
            
            <!-- High score button -->
            <a href="">
                <rect
                    x="{(board/width div 2) - board/start + (buttons/distance * 2) + (buttons/width * 2) - (buttons/distance div 2)}"
                    y="{board/start * 0.5}"
                    id="highScore"
                    width="{buttons/width}" 
                    height="{buttons/height}"
                    rx="{buttons/roundUP}" 
                    ry="{buttons/roundUp}"
                    style="{buttons/style}"/>					
                <text
                    x="{(board/width div 2) - board/start + (buttons/distance * 2) + (buttons/width * 2.5) - (buttons/distance div 2)}"
                    y="{(board/start * 0.5) + (buttons/height * 0.7)}"
                    text-anchor="middle"
                    ffont-size="{0.2 * house/width}"
                    style="{buttons/textStyle}">High Score
                    <xsl:value-of select="concat(menu/highscoreButton/desc, ' ', $GameState/game/players/highestScore)"/>
                </text>
            </a>
            
            
            <xsl:call-template name="board">
                <xsl:with-param name="count" select="board/count"/>
            </xsl:call-template>
            
            <!-- Create houses for both players -->
            <xsl:call-template name="createHouses">
                <xsl:with-param name="houses" select="house/nrOfHouses"/>
            </xsl:call-template>
            
            
            <!-- Create stores for both players -->
            <!-- Top = Player 1, Bot = Player 2 -->
            <xsl:choose>
                <xsl:when test="$GameState/game/players/turn = '1'">
                    <!-- Player 1, Top Store -->
                    <g>                        
                        <use 
                            x="0" 
                            y="{layout/posStartY + layout/stockVerticalPos}"
                            xlink:href="#storeThisPlayerTemplate"/>
                        <text
                            x="{stock/basicCircle/radiusOne}"
                            y="{layout/posStartY * 2.5}"
                            text-anchor="middle"
                            font-size="{stock/basicCircle/radiusOne}"
                            style="{stock/style}">
                            <xsl:value-of select="$GameState/game/board/layer[1]/store"/>
                        </text>
                    </g>
                    
                    <!-- Player 1, Bot Store -->
                    <g>
                        <use				
                            x="{layout/posStartX + layout/stockHorizontalPos}"
                            y="{layout/posStartY + layout/stockVerticalPos}" 
                            xlink:href="#storeOtherPlayerTemplate"/>
                        <text
                            x="{layout/posStartX + layout/stockHorizontalPos + stock/basicCircle/radiusOne}"
                            y="{layout/posStartY * 2.5}" 
                            text-anchor="middle"
                            font-size="{stock/basicCircle/radiusOne}"
                            style="{stock/style}">
                            <xsl:value-of select="$GameState/game/board/layer[2]/store"/>
                        </text>
                    </g>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Player 2, Top Store -->
                    <g>                        
                        <use 
                            x="{layout/posStartX + layout/stockHorizontalPos}" 
                            y="{layout/posStartY + layout/stockVerticalPos}"
                            xlink:href="#storeOtherPlayerTemplate"/>
                        <text
                            x="{layout/posStartX + layout/stockHorizontalPos + stock/basicCircle/radiusOne}" 
                            y="{layout/posStartY * 2.5}"
                            text-anchor="middle"
                            font-size="{stock/basicCircle/radiusOne}"
                            style="{stock/style}">
                            <xsl:value-of select="$GameState/game/board/layer[1]/store"/>
                        </text>
                    </g>
                    
                    <!-- Player 2, Bot Store -->
                    <g>
                        <use
                            x="0"
                            y="{layout/posStartY + layout/stockVerticalPos}"
                            xlink:href="#storeThisPlayerTemplate"/>
                        <text
                            x="{(layout/posStartX + stock/basicCircle/radiusOne) div 2}"
                            y="{layout/posStartY * 2.5}"
                            text-anchor="middle"
                            font-size="{stock/basicCircle/radiusOne}"
                            style="{stock/style}">
                            <xsl:value-of select="$GameState/game/board/layer[2]/store"/>
                        </text>
                    </g>
                </xsl:otherwise>
            </xsl:choose>
            
            
                  
        </svg>
    </xsl:template>


	
    <!-- Recursion to create the board -->
    
    <xsl:template name="board">
        
        <xsl:param name="count"/>
        
            <xsl:if test="$count != 4">            
         
                <svg>                
                    <rect 
                        x="{board/start + 4*$count}"
                        y="{board/start + 4*$count}"
                        width="{board/width - 4*2*$count}"
                        height="{board/height - 4*2*$count}"
                        rx="{board/roundUp}" ry="{board/roundUp}"
                        style="{board/style}" />                
                </svg>
                <xsl:call-template name="board">
                    <xsl:with-param name="count" select="$count + 1" />
                </xsl:call-template>
            
            </xsl:if>
        
        <text x="{(board/width div 2) + 10}"  y="{board/height - 23}" style="{board/textStyle}">Mancala</text>
        
    </xsl:template>
    
    <!-- Recursion to create the houses -->
    
    <xsl:template name="createHouses"> 
        <xsl:param name="houses"/>
        <xsl:if test="$houses &gt; 0">
            <xsl:choose>
                <xsl:when test="$GameState/game/players/turn = '1'">
                    <!-- Player 1, Upper houses -->
                    <g>
                        <xsl:choose>
                            <xsl:when test="$GameState/game/board/layer[1]/house[7 - $houses] = 0">
                                <use 
                                    x="{layout/posStartX + (layout/houseOuterWidth + layout/distanceHorizontalHouse) * $houses}" 
                                    y="{layout/posStartY}"
                                    xlink:href="#houseThisPlayerTemplate"/>					
                                <text
                                    x="{layout/posStartX + (layout/houseOuterWidth + layout/distanceHorizontalHouse) * $houses + 0.5 * layout/houseOuterWidth}"
                                    y="{layout/posStartY + 0.7 * layout/houseOuterWidth}"
                                    text-anchor="middle"
                                    font-size="{0.3 * layout/houseInnerWidth}"
                                    style="{layout/textstyleThisPlayer}">
                                    <xsl:value-of select="$GameState/game/board/layer[1]/house[7 - $houses]"/>
                                </text>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="clicked/{7 - $houses}" >
                                    <use 
                                        x="{layout/posStartX + (layout/houseOuterWidth + layout/distanceHorizontalHouse) * $houses}" 
                                        y="{layout/posStartY}"
                                        xlink:href="#houseThisPlayerTemplate"/>					
                                    <text
                                        x="{layout/posStartX + (layout/houseOuterWidth + layout/distanceHorizontalHouse) * $houses + 0.5 * layout/houseOuterWidth}"
                                        y="{layout/posStartY + 0.7 * layout/houseOuterWidth}"
                                        text-anchor="middle"
                                        font-size="{0.3 * layout/houseInnerWidth}"
                                        style="{layout/textstyleThisPlayer}">
                                        <xsl:value-of select="$GameState/game/board/layer[1]/house[7 - $houses]"/>
                                    </text>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </g>			
                    
                    <!-- Player 1, Bottom houses -->
                    <g>
                        <use 
                            x="{layout/posStartX + (layout/houseOuterWidth + layout/distanceHorizontalHouse) * $houses}" 
                            y="{layout/posStartY + layout/houseOuterWidth + layout/distanceVertitalHouse}" 
                            xlink:href="#houseOtherPlayerTemplate"/>
                        <text
                            x="{layout/posStartX + (layout/houseOuterWidth + layout/distanceHorizontalHouse) * $houses + 0.5 * layout/houseOuterWidth}"
                            y="{layout/posStartY + layout/houseOuterWidth + layout/distanceVertitalHouse + 0.7 * layout/houseOuterWidth}"
                            text-anchor="middle"
                            font-size="{0.3 * layout/houseInnerWidth}"
                            style="{layout/textstyleOtherPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[2]/house[0 + $houses]"/>
                        </text>
                    </g>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Player 2, Upper houses -->
                    <g>
                        <use 
                            x="{layout/posStartX + (layout/houseOuterWidth + layout/distanceHorizontalHouse) * $houses}" 
                            y="{layout/posStartY}"
                            xlink:href="#houseOtherPlayerTemplate"/>					
                        <text
                            x="{layout/posStartX + (layout/houseOuterWidth + layout/distanceHorizontalHouse) * $houses + 0.5 * layout/houseOuterWidth}"
                            y="{layout/posStartY + 0.7 * layout/houseOuterWidth}"
                            text-anchor="middle"
                            font-size="{0.3 * layout/houseInnerWidth}"
                            style="{layout/textstyleOtherPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[1]/house[7 - $houses]"/>
                        </text>
                    </g>			
                    
                    <!-- Player 2, Bottom houses -->
                    <g>
                        <xsl:choose>
                            <xsl:when test="$GameState/game/board/layer[2]/house[0 + $houses] = 0">
                                <use 
                                    x="{layout/posStartX + (layout/houseOuterWidth + layout/distanceHorizontalHouse) * $houses}" 
                                    y="{layout/posStartY + layout/houseOuterWidth + layout/distanceVertitalHouse}" 
                                    xlink:href="#houseThisPlayerTemplate"/>
                                <text
                                    x="{layout/posStartX + (layout/houseOuterWidth + layout/distanceHorizontalHouse) * $houses + 0.5 * layout/houseOuterWidth}"
                                    y="{layout/posStartY + layout/houseOuterWidth + layout/distanceVertitalHouse + 0.7 * layout/houseOuterWidth}"
                                    text-anchor="middle"
                                    font-size="{0.3 * layout/houseInnerWidth}"
                                    style="{layout/textstyleThisPlayer}">
                                    <xsl:value-of select="$GameState/game/board/layer[2]/house[0 + $houses]"/>
                                </text>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="clicked/{$houses + 7}" >
                                    <use 
                                        x="{layout/posStartX + (layout/houseOuterWidth + layout/distanceHorizontalHouse) * $houses}" 
                                        y="{layout/posStartY + layout/houseOuterWidth + layout/distanceVertitalHouse}" 
                                        xlink:href="#houseThisPlayerTemplate"/>
                                    <text
                                        x="{layout/posStartX + (layout/houseOuterWidth + layout/distanceHorizontalHouse) * $houses + 0.5 * layout/houseOuterWidth}"
                                        y="{layout/posStartY + layout/houseOuterWidth + layout/distanceVertitalHouse + 0.7 * layout/houseOuterWidth}"
                                        text-anchor="middle"
                                        font-size="{0.3 * layout/houseInnerWidth}"
                                        style="{layout/textstyleThisPlayer}">
                                        <xsl:value-of select="$GameState/game/board/layer[2]/house[0 + $houses]"/>
                                    </text>
                                </a>
                            </xsl:otherwise>   
                        </xsl:choose>                         
                    </g>
                </xsl:otherwise>
            </xsl:choose>            			
            
            <xsl:call-template name="createHouses">
                <xsl:with-param name="houses" select="$houses - 1"/>
            </xsl:call-template>
        </xsl:if>      
    </xsl:template>
    

    

</xsl:stylesheet>
