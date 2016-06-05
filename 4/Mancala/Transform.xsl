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
					.pit{
						fill:   		white;
						stroke: 		black;
						stroke-width: 	2;
					}
				]]>
			</style>
			-->
			
			<defs>
				<rect
					id="pit0"
					width="{pits/width}" height="{pits/height}"
					rx="{pits/roundX}"	ry="{pits/roundY}"
					style="{pits/style}"/>
					
				<circle
					id="seed"
					r="{((pits/width + pits/height) div 2) div 12}"
					style="{seed/style}"/>

				<circle
					id="house"
					r="{houses/radius}"
					cx="{houses/radius}"
					style="{houses/style}"/>
				
				<g id="pit1">
					<use xlink:href="#pit0"/>
					<use x="{pits/width div 2}" y="{pits/height div 2}" xlink:href="#seed"/>
				</g>
				
				<g id="pit2">
					<use xlink:href="#pit0"/>
					<use x="{pits/width div 3}" y="{pits/height div 2}" xlink:href="#seed"/>
					<use x="{pits/width * 2 div 3}" y="{pits/height div 2}" xlink:href="#seed"/>
				</g>
				
				<g id="pit3">
					<use xlink:href="#pit0"/>
					<use x="{pits/width div 2}" y="{pits/height div 3}" xlink:href="#seed"/>
					<use x="{pits/width div 3}" y="{pits/height * 2 div 3}" xlink:href="#seed"/>
					<use x="{pits/width * 2 div 3}" y="{pits/height * 2 div 3}" xlink:href="#seed"/>
				</g>
				
				<g id="pit4">
					<use xlink:href="#pit0"/>
					<use x="{pits/width div 3}" y="{pits/height div 3}" xlink:href="#seed"/>
					<use x="{pits/width * 2 div 3}" y="{pits/height div 3}" xlink:href="#seed"/>
					<use x="{pits/width div 3}" y="{pits/height * 2 div 3}" xlink:href="#seed"/>
					<use x="{pits/width * 2 div 3}" y="{pits/height * 2 div 3}" xlink:href="#seed"/>
				</g>
				
				<g id="pit5">
					<use xlink:href="#pit0"/>
					<use x="{pits/width div 4}" y="{pits/height div 4}" xlink:href="#seed"/>
					<use x="{pits/width * 3 div 4}" y="{pits/height div 4}" xlink:href="#seed"/>
					<use x="{pits/width div 4}" y="{pits/height * 3 div 4}" xlink:href="#seed"/>
					<use x="{pits/width * 3 div 4}" y="{pits/height * 3 div 4}" xlink:href="#seed"/>
					<use x="{pits/width div 2}" y="{pits/height div 2}" xlink:href="#seed"/>
				</g>
				
				<g id="pit6">
					<use xlink:href="#pit0"/>
					<use x="{pits/width div 3}" y="{pits/height div 4}" xlink:href="#seed"/>
					<use x="{pits/width * 2 div 3}" y="{pits/height div 4}" xlink:href="#seed"/>
					<use x="{pits/width div 3}" y="{pits/height * 2 div 4}" xlink:href="#seed"/>
					<use x="{pits/width * 2 div 3}" y="{pits/height * 2 div 4}" xlink:href="#seed"/>
					<use x="{pits/width div 3}" y="{pits/height * 3 div 4}" xlink:href="#seed"/>
					<use x="{pits/width * 2 div 3}" y="{pits/height * 3 div 4}" xlink:href="#seed"/>
				</g>
			</defs>
			
			<!-- Create pits for both players -->
			<xsl:call-template name="createPits">
				<xsl:with-param name="count" select="pits/pitCount"/>
			</xsl:call-template>
			
			<!-- Create houses for both players -->
			<g>
				<use 
					x="{layout/posStartX - layout/distancePitStore - houses/radius + layout/distancePitX}" 
					y="{layout/posStartY + pits/height + (layout/distancePitY div 2)}" 
					xlink:href="#house"/>
				<text
					x="{layout/posStartX - layout/distancePitStore + layout/distancePitX}"
					y="{layout/posStartY + pits/height + (layout/distancePitY div 2) + 0.35 * houses/radius}"
					text-anchor="middle"
					font-size="{houses/radius}"
					style="{houses/textstyle}">
						<xsl:value-of select="houses/house[1]"/>
				</text>
			</g>
			<g>
				<use				
					x="{layout/posStartX + layout/distancePitStore + (pits/width + layout/distancePitX) * pits/pitCount + houses/radius}"
					y="{layout/posStartY + pits/height + (layout/distancePitY div 2)}" 
					xlink:href="#house"/>
				<text
					x="{layout/posStartX + layout/distancePitStore + (pits/width + layout/distancePitX) * pits/pitCount + 2 * houses/radius}"
					y="{layout/posStartY + pits/height + (layout/distancePitY div 2) + 0.35 * houses/radius}"
					text-anchor="middle"
					font-size="{houses/radius}"
					style="{houses/textstyle}">
						<xsl:value-of select="houses/house[2]"/>
				</text>
			</g>
				
		</svg>
	</xsl:template>
	
	<!-- Recursion -->
	<xsl:template name="createPits"> 
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<!-- Upper pits -->
			<use 
				x="{layout/posStartX + (pits/width + layout/distancePitX) * $count}" 
				y="{layout/posStartY}" 
				xlink:href="{concat('#pit', pits/top/pit[0+$count])}"/>
				
			<!-- Bottom pits -->
			<use 
				x="{layout/posStartX + (pits/width + layout/distancePitX) * $count}" 
				y="{layout/posStartY + pits/height + layout/distancePitY}" 
				xlink:href="{concat('#pit', pits/bot/pit[0+$count])}"/>
				
			<xsl:call-template name="createPits">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>      
	</xsl:template>
</xsl:stylesheet>