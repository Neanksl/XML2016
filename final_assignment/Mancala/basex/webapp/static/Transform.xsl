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


    <!-- This XSLT uses two XML sources, where Static.xml is declared 
    and GameState.xml must be imported. -->
    <xsl:variable name="GameState" select="document('http://localhost:8984/gamestate')"/>

    <xsl:template match="static">        
        <svg width="{board/width}" height="{board/height}">				
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
            </defs>
            
            <!-- Create reset game button -->
            <g>
                <a href="{menu/resetGame/link}">
                    <rect
                        x="{menu/resetGame/posX}" 
                        y="{menu/resetGame/posY}"
                        id="resetGameButton"
                        width="{menu/resetGame/width}" height="{menu/resetGame/height}"
                        rx="{menu/resetGame/roundX}" ry="{menu/resetGame/roundY}"
                        style="{menu/resetGame/style}"/>
					
                    <text
                        x="{menu/resetGame/posX + 0.5 * menu/resetGame/width}"
                        y="{menu/resetGame/posY + 0.6 * menu/resetGame/height}"
                        text-anchor="middle"
                        font-size="{0.2 * menu/resetGame/width}"
                        style="{menu/resetGame/textstyle}">
                        Try again
                    </text>
                </a>
            </g>
            
            <!-- Create new game button -->
            <g>
                <a href="{menu/newGame/link}">
                    <rect
                        x="{menu/newGame/posX}" 
                        y="{menu/newGame/posY}"
                        id="newGameButton"
                        width="{menu/newGame/width}" height="{menu/newGame/height}"
                        rx="{menu/newGame/roundX}" ry="{menu/newGame/roundY}"
                        style="{menu/newGame/style}"/>
					
                    <text
                        x="{menu/newGame/posX + 0.5 * menu/newGame/width}"
                        y="{menu/newGame/posY + 0.6 * menu/newGame/height}"
                        text-anchor="middle"
                        font-size="{0.2 * menu/newGame/width}"
                        style="{menu/newGame/textstyle}">
                        Start over
                    </text>
                </a>
            </g>
					
            <!-- Create houses for both players -->
            <xsl:call-template name="createHouses">
                <xsl:with-param name="count" select="house/nrOfHouses"/>
            </xsl:call-template>
					
            <!-- Create stores for both players -->
            <!-- Top = Player 1, Bot = Player 2 -->
            <xsl:choose>
                <xsl:when test="$GameState/game/players/turn = '1'">
                    <!-- Top Store -->
                    <g>                        
                        <use 
                            x="{layout/posStartX - layout/distanceHouseStore - store/radius + layout/distanceHouseX}" 
                            y="{layout/posStartY + house/height + (layout/distanceHouseY div 2)}"
                            xlink:href="#storeThisPlayerTemplate"/>
                        <text
                            x="{layout/posStartX - layout/distanceHouseStore + layout/distanceHouseX}"
                            y="{layout/posStartY + house/height + (layout/distanceHouseY div 2) + 0.35 * store/radius}"
                            text-anchor="middle"
                            font-size="{store/radius}"
                            style="{store/textstyleThisPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[1]/store"/>
                        </text>
                    </g>
                    
                    <!-- Bot Store -->
                    <g>
                        <use				
                            x="{layout/posStartX + layout/distanceHouseStore + (house/width + layout/distanceHouseX) * house/nrOfHouses + store/radius}"
                            y="{layout/posStartY + house/height + (layout/distanceHouseY div 2)}" 
                            xlink:href="#storeOtherPlayerTemplate"/>
                        <text
                            x="{layout/posStartX + layout/distanceHouseStore + (house/width + layout/distanceHouseX) * house/nrOfHouses + 2 * store/radius}"
                            y="{layout/posStartY + house/height + (layout/distanceHouseY div 2) + 0.35 * store/radius}"
                            text-anchor="middle"
                            font-size="{store/radius}"
                            style="{store/textstyleOtherPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[2]/store"/>
                        </text>
                    </g>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Top Store -->
                    <g>                        
                        <use 
                            x="{layout/posStartX - layout/distanceHouseStore - store/radius + layout/distanceHouseX}" 
                            y="{layout/posStartY + house/height + (layout/distanceHouseY div 2)}"
                            xlink:href="#storeOtherPlayerTemplate"/>
                        <text
                            x="{layout/posStartX - layout/distanceHouseStore + layout/distanceHouseX}"
                            y="{layout/posStartY + house/height + (layout/distanceHouseY div 2) + 0.35 * store/radius}"
                            text-anchor="middle"
                            font-size="{store/radius}"
                            style="{store/textstyleOtherPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[1]/store"/>
                        </text>
                    </g>
                    
                    <!-- Bot Store -->
                    <g>
                        <use				
                            x="{layout/posStartX + layout/distanceHouseStore + (house/width + layout/distanceHouseX) * house/nrOfHouses + store/radius}"
                            y="{layout/posStartY + house/height + (layout/distanceHouseY div 2)}" 
                            xlink:href="#storeThisPlayerTemplate"/>
                        <text
                            x="{layout/posStartX + layout/distanceHouseStore + (house/width + layout/distanceHouseX) * house/nrOfHouses + 2 * store/radius}"
                            y="{layout/posStartY + house/height + (layout/distanceHouseY div 2) + 0.35 * store/radius}"
                            text-anchor="middle"
                            font-size="{store/radius}"
                            style="{store/textstyleThisPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[2]/store"/>
                        </text>
                    </g>
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
                    <!-- Upper houses -->
                    <g>
                        <a href="clicked/{7 - $count}" >
                            <use 
                                x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count}" 
                                y="{layout/posStartY}"
                                xlink:href="#houseThisPlayerTemplate"/>

                            <!-- xlink:href="{concat('#house', houses/up/house[0+$count])}"/> -->
					
                            <text
                                x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count + 0.5 * house/width}"
                                y="{layout/posStartY + 0.5 * house/height}"
                                text-anchor="middle"
                                font-size="{0.3 * house/width}"
                                style="{house/textstyleThisPlayer}">
                                <xsl:value-of select="$GameState/game/board/layer[1]/house[7 - $count]"/>
                            </text>
                        </a>
                    </g>			
				
                    <!-- Bottom houses -->
                    <g>
                        <!-- <a href="clicked/{$count + 7}" > -->
                        <use 
                            x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count}" 
                            y="{layout/posStartY + house/height + layout/distanceHouseY}" 
                            xlink:href="#houseOtherPlayerTemplate"/>
                        <text
                            x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count + 0.5 * house/width}"
                            y="{layout/posStartY + house/height + layout/distanceHouseY + 0.5 * house/height}"
                            text-anchor="middle"
                            font-size="{0.3 * house/width}"
                            style="{house/textstyleOtherPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[2]/house[0 + $count]"/>
                        </text>
                        <!-- </a> -->
                    </g>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Upper houses -->
                    <g>
                        <!-- <a href="clicked/{7 - $count}" > -->
                        <use 
                            x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count}" 
                            y="{layout/posStartY}"
                            xlink:href="#houseOtherPlayerTemplate"/>

                        <!-- xlink:href="{concat('#house', houses/up/house[0+$count])}"/> -->
					
                        <text
                            x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count + 0.5 * house/width}"
                            y="{layout/posStartY + 0.5 * house/height}"
                            text-anchor="middle"
                            font-size="{0.3 * house/width}"
                            style="{house/textstyleOtherPlayer}">
                            <xsl:value-of select="$GameState/game/board/layer[1]/house[7 - $count]"/>
                        </text>
                        <!-- </a> -->
                    </g>			
				
                    <!-- Bottom houses -->
                    <g>
                        <a href="clicked/{$count + 7}" >
                            <use 
                                x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count}" 
                                y="{layout/posStartY + house/height + layout/distanceHouseY}" 
                                xlink:href="#houseThisPlayerTemplate"/>
                            <text
                                x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count + 0.5 * house/width}"
                                y="{layout/posStartY + house/height + layout/distanceHouseY + 0.5 * house/height}"
                                text-anchor="middle"
                                font-size="{0.3 * house/width}"
                                style="{house/textstyleThisPlayer}">
                                <xsl:value-of select="$GameState/game/board/layer[2]/house[0 + $count]"/>
                            </text>
                        </a>
                    </g>
                </xsl:otherwise>
            </xsl:choose>            			
				
            <xsl:call-template name="createHouses">
                <xsl:with-param name="count" select="$count - 1"/>
            </xsl:call-template>
        </xsl:if>      
    </xsl:template>
</xsl:stylesheet>
