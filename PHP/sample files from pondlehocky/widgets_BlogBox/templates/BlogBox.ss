<br>
<div class="blog_rail">
			<h3>Blog</h3>
				
					<% loop $getBlog().limit(4) %>
					<p>
						<a class="$LinkingMode plan-link" href="$Link">$Title</a>
					</p>
					<% end_loop %>
				<!-- 	<p>
						Lorem ipsum dolor sit amet, consetetur sa
						dipscing elitr, sed diam nonumy
					</p>
					<p>
						Lorem ipsum dolor sit amet, consetetur sa
						dipscing elitr, sed diam nonumy
					</p> -->
					<a href="/blog/"><img class="learn_rail" src="{$ThemeDir}/gfx/learn_more_rail.png"/></a>
				</div>
				