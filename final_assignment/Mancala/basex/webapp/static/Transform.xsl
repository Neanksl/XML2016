<?xml version="1.0"?>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink">

<xsl:output
	method="xml"
	indent="yes"
	standalone="no"
	doctype-public="-//W3C//DTD SVG 1.1//EN"
	doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
	media-type="image/svg"/>

	<!-- This XSLT uses two XML sources, where Static.xml is declared 
	and GameState.xml must be imported. -->
	<xsl:variable name="GameState" select="document('http://localhost:8984/gamestate')"/>

	<xsl:template match="static">
		<html>
			<body>
				TODO
				<svg width="{board/width}" height="{board/height}">				
					<defs>
						<rect
							id="houseTemplate"
							width="{house/width}" height="{house/height}"
							rx="{house/roundX}"	ry="{house/roundY}"
							style="{house/style}"/>
							
						<circle
							id="seedTemplate"
							r="{((house/width + house/height) div 2) div 12}"
							style="{seed/style}"/>

						<circle
							id="storeTemplate"
							r="{store/radius}"
							cx="{store/radius}"
							style="{store/style}"/>
					</defs>
					
					<!-- Create houses for both players -->
					<xsl:call-template name="createHouses">
						<xsl:with-param name="count" select="house/nrOfHouses"/>
					</xsl:call-template>
					
					<!-- Create stores for both players -->
					<g>
						<use 
							x="{layout/posStartX - layout/distanceHouseStore - store/radius + layout/distanceHouseX}" 
							y="{layout/posStartY + house/height + (layout/distanceHouseY div 2)}" 
							xlink:href="#storeTemplate"/>
						<text
							x="{layout/posStartX - layout/distanceHouseStore + layout/distanceHouseX}"
							y="{layout/posStartY + house/height + (layout/distanceHouseY div 2) + 0.35 * store/radius}"
							text-anchor="middle"
							font-size="{store/radius}"
							style="{store/textstyle}">
								<xsl:value-of select="$GameState/game/board/layer[1]/store"/>
						</text>
					</g>
					<g>
						<use				
							x="{layout/posStartX + layout/distanceHouseStore + (house/width + layout/distanceHouseX) * house/nrOfHouses + store/radius}"
							y="{layout/posStartY + house/height + (layout/distanceHouseY div 2)}" 
							xlink:href="#storeTemplate"/>
						<text
							x="{layout/posStartX + layout/distanceHouseStore + (house/width + layout/distanceHouseX) * house/nrOfHouses + 2 * store/radius}"
							y="{layout/posStartY + house/height + (layout/distanceHouseY div 2) + 0.35 * store/radius}"
							text-anchor="middle"
							font-size="{store/radius}"
							style="{store/textstyle}">
								<xsl:value-of select="$GameState/game/board/layer[2]/store"/>
						</text>
					</g>
						
				</svg>
			</body>
		</html>
	</xsl:template>
	
	<!-- Recursion -->
	<xsl:template name="createHouses"> 
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<!-- Upper houses -->
			<g>
				<use 
					x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count}" 
					y="{layout/posStartY}"
					xlink:href="#houseTemplate"/>
					<!-- xlink:href="{concat('#house', houses/up/house[0+$count])}"/> -->
					
				<text
					x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count + 0.5 * house/width}"
					y="{layout/posStartY + 0.5 * house/height}"
					text-anchor="middle"
					font-size="{0.3 * house/width}"
					style="{house/textstyle}">
						<xsl:value-of select="$GameState/game/board/layer[1]/house[0+$count]"/>
				</text>
			</g>
			
				
			<!-- Bottom houses -->
			<g>
				<use 
					x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count}" 
					y="{layout/posStartY + house/height + layout/distanceHouseY}" 
					xlink:href="#houseTemplate"/>
				<text
					x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count + 0.5 * house/width}"
					y="{layout/posStartY + house/height + layout/distanceHouseY + 0.5 * house/height}"
					text-anchor="middle"
					font-size="{0.3 * house/width}"
					style="{house/textstyle}">
						<xsl:value-of select="$GameState/game/board/layer[2]/house[0+$count]"/>
				</text>
			</g>			
				
			<xsl:call-template name="createHouses">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>      
	</xsl:template>
</xsl:stylesheet>