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
					width="{house/width}" height="{house/height}"
					rx="{house/roundX}"	ry="{house/roundY}"
					style="{house/style}"/>
					
				<circle
					id="seed"
					r="{((house/width + house/height) div 2) div 12}"
					style="{seed/style}"/>

				<circle
					id="store"
					r="{store/radius}"
					cx="{store/radius}"
					style="{store/style}"/>
				
				<g id="house1">
					<use xlink:href="#house0"/>
					<use x="{house/width div 2}" y="{house/height div 2}" xlink:href="#seed"/>
				</g>
				
				<g id="house2">
					<use xlink:href="#house0"/>
					<use x="{house/width div 3}" y="{house/height div 2}" xlink:href="#seed"/>
					<use x="{house/width * 2 div 3}" y="{house/height div 2}" xlink:href="#seed"/>
				</g>
				
				<g id="house3">
					<use xlink:href="#house0"/>
					<use x="{house/width div 2}" y="{house/height div 3}" xlink:href="#seed"/>
					<use x="{house/width div 3}" y="{house/height * 2 div 3}" xlink:href="#seed"/>
					<use x="{house/width * 2 div 3}" y="{house/height * 2 div 3}" xlink:href="#seed"/>
				</g>
				
				<g id="house4">
					<use xlink:href="#house0"/>
					<use x="{house/width div 3}" y="{house/height div 3}" xlink:href="#seed"/>
					<use x="{house/width * 2 div 3}" y="{house/height div 3}" xlink:href="#seed"/>
					<use x="{house/width div 3}" y="{house/height * 2 div 3}" xlink:href="#seed"/>
					<use x="{house/width * 2 div 3}" y="{house/height * 2 div 3}" xlink:href="#seed"/>
				</g>
				
				<g id="house5">
					<use xlink:href="#house0"/>
					<use x="{house/width div 4}" y="{house/height div 4}" xlink:href="#seed"/>
					<use x="{house/width * 3 div 4}" y="{house/height div 4}" xlink:href="#seed"/>
					<use x="{house/width div 4}" y="{house/height * 3 div 4}" xlink:href="#seed"/>
					<use x="{house/width * 3 div 4}" y="{house/height * 3 div 4}" xlink:href="#seed"/>
					<use x="{house/width div 2}" y="{house/height div 2}" xlink:href="#seed"/>
				</g>
				
				<g id="house6">
					<use xlink:href="#house0"/>
					<use x="{house/width div 3}" y="{house/height div 4}" xlink:href="#seed"/>
					<use x="{house/width * 2 div 3}" y="{house/height div 4}" xlink:href="#seed"/>
					<use x="{house/width div 3}" y="{house/height * 2 div 4}" xlink:href="#seed"/>
					<use x="{house/width * 2 div 3}" y="{house/height * 2 div 4}" xlink:href="#seed"/>
					<use x="{house/width div 3}" y="{house/height * 3 div 4}" xlink:href="#seed"/>
					<use x="{house/width * 2 div 3}" y="{house/height * 3 div 4}" xlink:href="#seed"/>
				</g>
			</defs>
			
			<!-- Create houses for both players -->
			<xsl:call-template name="createHouses">
				<xsl:with-param name="count" select="layout/nrOfHouses"/>
			</xsl:call-template>
			
			<!-- Create stores for both players -->
			<use 
				x="{layout/posStartX - layout/distanceHouseStore - store/radius + layout/distanceHouseX}" 
				y="{layout/posStartY + house/height + (layout/distanceHouseY div 2)}" 
				xlink:href="#store"/>
			<use				
				x="{layout/posStartX + layout/distanceHouseStore + (house/width + layout/distanceHouseX) * layout/nrOfHouses + store/radius}"
				y="{layout/posStartY + house/height + (layout/distanceHouseY div 2)}" 
				xlink:href="#store"/>		
				
		</svg>
	</xsl:template>
	
	<!-- Recursion -->
	<xsl:template name="createHouses"> 
		<xsl:param name="count"/>
		<xsl:if test="$count > 0">
			<use 
				x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count}" 
				y="{layout/posStartY}" 
				xlink:href="{concat('#house','1')}"/>
			<use 
				x="{layout/posStartX + (house/width + layout/distanceHouseX) * $count}" 
				y="{layout/posStartY + house/height + layout/distanceHouseY}" 
				xlink:href="{concat('#house','1')}"/>
			<xsl:call-template name="createHouses">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>      
	</xsl:template>

</xsl:stylesheet>