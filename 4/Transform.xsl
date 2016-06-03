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

	<xsl:template match="mancala">
		<svg width="{svg/width}" height="{svg/height}">	
			
			<!--
			<style type="text/css" >
				<![CDATA[
					.house{
						fill:   		white;
						stroke: 		black;
						stroke-width: 	2;
					}
				]]>
			</style>
			-->
			
			<defs>
				<rect
					id="house0"
					width="{houses/width}" height="{houses/height}"
					rx="{houses/roundX}"	ry="{houses/roundY}"
					style="{houses/style}"/>
					
				<circle
					id="seed"
					r="{((houses/width + houses/height) div 2) div 12}"
					style="{seed/style}"/>

				<circle
					id="store"
					r="{stores/radius}"
					cx="{stores/radius}"
					style="{stores/style}"/>
				
				<g id="house1">
					<use xlink:href="#house0"/>
					<use x="{houses/width div 2}" y="{houses/height div 2}" xlink:href="#seed"/>
				</g>
				
				<g id="house2">
					<use xlink:href="#house0"/>
					<use x="{houses/width div 3}" y="{houses/height div 2}" xlink:href="#seed"/>
					<use x="{houses/width * 2 div 3}" y="{houses/height div 2}" xlink:href="#seed"/>
				</g>
				
				<g id="house3">
					<use xlink:href="#house0"/>
					<use x="{houses/width div 2}" y="{houses/height div 3}" xlink:href="#seed"/>
					<use x="{houses/width div 3}" y="{houses/height * 2 div 3}" xlink:href="#seed"/>
					<use x="{houses/width * 2 div 3}" y="{houses/height * 2 div 3}" xlink:href="#seed"/>
				</g>
				
				<g id="house4">
					<use xlink:href="#house0"/>
					<use x="{houses/width div 3}" y="{houses/height div 3}" xlink:href="#seed"/>
					<use x="{houses/width * 2 div 3}" y="{houses/height div 3}" xlink:href="#seed"/>
					<use x="{houses/width div 3}" y="{houses/height * 2 div 3}" xlink:href="#seed"/>
					<use x="{houses/width * 2 div 3}" y="{houses/height * 2 div 3}" xlink:href="#seed"/>
				</g>
				
				<g id="house5">
					<use xlink:href="#house0"/>
					<use x="{houses/width div 4}" y="{houses/height div 4}" xlink:href="#seed"/>
					<use x="{houses/width * 3 div 4}" y="{houses/height div 4}" xlink:href="#seed"/>
					<use x="{houses/width div 4}" y="{houses/height * 3 div 4}" xlink:href="#seed"/>
					<use x="{houses/width * 3 div 4}" y="{houses/height * 3 div 4}" xlink:href="#seed"/>
					<use x="{houses/width div 2}" y="{houses/height div 2}" xlink:href="#seed"/>
				</g>
				
				<g id="house6">
					<use xlink:href="#house0"/>
					<use x="{houses/width div 3}" y="{houses/height div 4}" xlink:href="#seed"/>
					<use x="{houses/width * 2 div 3}" y="{houses/height div 4}" xlink:href="#seed"/>
					<use x="{houses/width div 3}" y="{houses/height * 2 div 4}" xlink:href="#seed"/>
					<use x="{houses/width * 2 div 3}" y="{houses/height * 2 div 4}" xlink:href="#seed"/>
					<use x="{houses/width div 3}" y="{houses/height * 3 div 4}" xlink:href="#seed"/>
					<use x="{houses/width * 2 div 3}" y="{houses/height * 3 div 4}" xlink:href="#seed"/>
				</g>
			</defs>
			
			<!-- Create houses for both players -->
			<xsl:call-template name="createHouses">
				<xsl:with-param name="count" select="houses/nrOfHouses"/>
			</xsl:call-template>
			
			<!-- Create stores for both players -->
			<g>
				<use 
					x="{layout/posStartX - layout/distanceHouseStore - stores/radius + layout/distanceHouseX}" 
					y="{layout/posStartY + houses/height + (layout/distanceHouseY div 2)}" 
					xlink:href="#store"/>
				<text
					x="{layout/posStartX - layout/distanceHouseStore + layout/distanceHouseX}"
					y="{layout/posStartY + houses/height + (layout/distanceHouseY div 2) + 0.35 * stores/radius}"
					text-anchor="middle"
					font-size="{stores/radius}"
					style="{stores/textstyle}">
						<xsl:value-of select="stores/store[1]"/>
				</text>
			</g>
			<g>
				<use				
					x="{layout/posStartX + layout/distanceHouseStore + (houses/width + layout/distanceHouseX) * houses/nrOfHouses + stores/radius}"
					y="{layout/posStartY + houses/height + (layout/distanceHouseY div 2)}" 
					xlink:href="#store"/>
				<text
					x="{layout/posStartX + layout/distanceHouseStore + (houses/width + layout/distanceHouseX) * houses/nrOfHouses + 2 * stores/radius}"
					y="{layout/posStartY + houses/height + (layout/distanceHouseY div 2) + 0.35 * stores/radius}"
					text-anchor="middle"
					font-size="{stores/radius}"
					style="{stores/textstyle}">
						<xsl:value-of select="stores/store[2]"/>
				</text>
			</g>
				
		</svg>
	</xsl:template>
	
	<!-- Recursion -->
	<xsl:template name="createHouses"> 
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<!-- Upper houses -->
			<use 
				x="{layout/posStartX + (houses/width + layout/distanceHouseX) * $count}" 
				y="{layout/posStartY}" 
				xlink:href="{concat('#house', houses/up/house[0+$count])}"/>
				
			<!-- Bottom houses -->
			<use 
				x="{layout/posStartX + (houses/width + layout/distanceHouseX) * $count}" 
				y="{layout/posStartY + houses/height + layout/distanceHouseY}" 
				xlink:href="{concat('#house', houses/bot/house[0+$count])}"/>
				
			<xsl:call-template name="createHouses">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>      
	</xsl:template>
</xsl:stylesheet>