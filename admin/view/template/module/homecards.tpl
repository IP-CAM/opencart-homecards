<?php echo $header; ?> 
<style>
    #homecards-category > div {
        cursor: move;
    }
</style>
<div id="content">
    <div class="breadcrumb">
        <?php foreach ($breadcrumbs as $breadcrumb) { ?> 
            <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
        <?php } ?> 
    </div>
    <?php if ($error_warning) { ?> 
        <div class="warning"><?php echo $error_warning; ?></div>
    <?php } ?> 
    <div class="box">
        <div class="heading">
            <h1><img src="view/image/module.png" alt="" /> <?php echo $heading_title; ?></h1>
            <div class="buttons">
                <a onclick="$('#form').submit();" class="button"><?php echo $button_save; ?></a>
                <a onclick="location = '<?php echo $cancel; ?>';" class="button"><?php echo $button_cancel; ?></a>
            </div>
        </div>
        <div class="content">
            <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
                <table id="module" class="list">
                    <thead>
                        <tr>
                            <td class="left"><?php echo $entry_layout; ?></td>
                            <td class="left"><?php echo $entry_position; ?></td>
                            <td class="left"><?php echo $entry_status; ?></td>
                            <td class="left"><?php echo $entry_main_image; ?></td>
                            <td class="left"><?php echo $entry_child_image; ?></td>
                            <td class="right"><?php echo $entry_sort_order; ?></td>
                            <td></td>
                        </tr>
                    </thead>
                    <?php foreach ($modules as $module_row => $module) { ?> 
                        <tbody id="module-row<?php echo $module_row; ?>">
                            <tr>
                                <td class="left">
                                    <select name="homecards_module[<?php echo $module_row; ?>][layout_id]">
                                        <?php foreach ($layouts as $layout) { ?> 
                                            <option value="<?php echo $layout['layout_id']; ?>"<?php echo $layout['layout_id'] == $module['layout_id'] ? ' selected="selected"' : ''; ?>><?php echo $layout['name']; ?></option>
                                        <?php } ?> 
                                    </select>
                                </td>
                                <td class="left">
                                    <select name="homecards_module[<?php echo $module_row; ?>][position]">
                                        <?php foreach ($positions as $position) { ?> 
                                            <option value="<?php echo $position; ?>"<?php echo $module['position'] == $position ? ' selected="selected"' : ''; ?>><?php echo ${'text_'.$position}; ?></option>
                                        <?php } ?> 
                                    </select>
                                </td>
                                <td class="left">
                                    <select name="homecards_module[<?php echo $module_row; ?>][status]">
                                        <option value="1"<?php echo $module['status'] ? ' selected="selected"' : ''; ?>><?php echo $text_enabled; ?></option>
                                        <option value="0"<?php echo $module['status'] ? '' : ' selected="selected"'; ?>><?php echo $text_disabled; ?></option>
                                    </select>
                                </td>
                                <td class="left">
                                    <input name="homecards_module[<?php echo $module_row; ?>][main_image_w]" value="<?php echo $module['main_image_w']; ?>" size="3">x<input name="homecards_module[<?php echo $module_row; ?>][main_image_h]" value="<?php echo $module['main_image_h']; ?>" size="3">
                                </td>
                                <td class="left">
                                    <input name="homecards_module[<?php echo $module_row; ?>][child_image_w]" value="<?php echo $module['child_image_w']; ?>" size="3">x<input name="homecards_module[<?php echo $module_row; ?>][child_image_h]" value="<?php echo $module['child_image_h']; ?>" size="3">
                                </td>
                                <td class="right">
                                    <input type="text" name="homecards_module[<?php echo $module_row; ?>][sort_order]" value="<?php echo $module['sort_order']; ?>" size="3" />
                                </td>
                                <td class="left">
                                    <a onclick="$('#module-row<?php echo $module_row; ?>').remove();" class="button"><?php echo $button_remove; ?></a>
                                </td>
                            </tr>
                        </tbody>
                    <?php } ?> 
                    <tfoot>
                        <tr>
                            <td colspan="6"></td>
                            <td class="left"><a onclick="addModule();" class="button"><?php echo $button_add_module; ?></a></td>
                        </tr>
                    </tfoot>
                </table>
                <h2><?= $text_select_categories ?></h2>
                <p class="help"><?= $text_select_categories_description ?></p>
                <table class="form">
                    <tr>
                        <td><?php echo $entry_category; ?></td>
                        <td><input type="text" id="category" value="" /></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <div id="homecards-category" class="scrollbox">
                                <?php $class = 'odd'; ?>
                                <?php foreach ($homecards_categories as $homecards_category) { ?>
                                    <?php $class = ($class == 'even' ? 'odd' : 'even'); ?>
                                    <div id="homecards-category<?php echo $homecards_category['category_id']; ?>" class="<?php echo $class; ?>"><?php echo $homecards_category['name']; ?><img src="view/image/delete.png" alt="<?= $button_remove ?>" title="<?= $button_remove ?>" class="delete" />
                                        <input type="hidden" name="homecards_categories[]" value="<?php echo $homecards_category['category_id']; ?>" />
                                    </div>
                                <?php } ?>
                            </div>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>
</div>
<script type="text/javascript"><!--
    $( "#homecards-category" ).sortable({
        opacity: 0.5,
        stop: function(event, ui) {
            $('#homecards-category div:odd').attr('class', 'odd');
            $('#homecards-category div:even').attr('class', 'even');
        }
    });
    
    // Category
    $('#category').autocomplete({
        delay: 500,
        source: function(request, response) {
            $.ajax({
                url: 'index.php?route=catalog/category/autocomplete&token=<?php echo $token; ?>&filter_name=' +  encodeURIComponent(request.term),
                dataType: 'json',
                success: function(json) {
                    response($.map(json, function(item) {
                        return {
                            label: item.name,
                            value: item.category_id
                        }
                    }));
                }
            });
        },
        select: function(event, ui) {
            $('#homecards-category' + ui.item.value).remove();

            $('#homecards-category').append('<div id="homecards-category' + ui.item.value + '">' + ui.item.label + '<img src="view/image/delete.png" alt="" /><input type="hidden" name="homecards_categories[]" value="' + ui.item.value + '" /></div>');

            $('#homecards-category div:odd').attr('class', 'odd');
            $('#homecards-category div:even').attr('class', 'even');

            return false;
        },
        focus: function(event, ui) {
            return false;
        }
    });

    $('#homecards-category div img.delete').live('click', function() {
        $(this).parent().remove();

        $('#homecards-category div:odd').attr('class', 'odd');
        $('#homecards-category div:even').attr('class', 'even');
    });

    var module_row = <?php echo isset($module_row) ? ++$module_row : 0; ?>;
    var EOL = "\n";

    function addModule() {	
        html  = '<tbody id="module-row' + module_row + '">' + EOL;
        html += '	<tr>' + EOL;
        html += '		<td class="left">' + EOL;
        html += '			<select name="homecards_module[' + module_row + '][layout_id]">' + EOL;
        <?php foreach ($layouts as $layout) { ?> 
            html += '				<option value="<?php echo $layout['layout_id']; ?>"><?php echo addslashes($layout['name']); ?></option>' + EOL;
        <?php } ?> 
        html += '			</select>' + EOL;
        html += '		</td>' + EOL;
        html += '		<td class="left">' + EOL;
        html += '			<select name="homecards_module[' + module_row + '][position]">' + EOL;
        <?php foreach ($positions as $position) { ?> 
            html += '				<option value="<?php echo $position; ?>"><?php echo ${'text_'.$position}; ?></option>' + EOL;
        <?php } ?> 
        html += '			</select>' + EOL;
        html += '		</td>' + EOL;
        html += '		<td class="left">' +EOL;
        html += '			<select name="homecards_module[' + module_row + '][status]">' + EOL;
        html += '				<option value="1"><?php echo $text_enabled; ?></option>' + EOL;
        html += '				<option value="0"><?php echo $text_disabled; ?></option>' + EOL;
        html += '			</select>' + EOL;
        html += '		</td>' + EOL;
        html += '		<td class="left">' + EOL;
        html += '			<input name="homecards_module[' + module_row + '][main_image_w]" value="" size="3">x<input name="homecards_module[' + module_row + '][main_image_h]" value="" size="3">' + EOL;
        html += '		</td>' + EOL;
        html += '		<td class="left">' + EOL;
        html += '			<input name="homecards_module[' + module_row + '][child_image_w]" value="" size="3">x<input name="homecards_module[' + module_row + '][child_image_h]" value="" size="3">' + EOL;
        html += '		</td>' + EOL;
        html += '		<td class="right">' + EOL;
        html += '			<input type="text" name="homecards_module[' + module_row + '][sort_order]" value="" size="3" />' + EOL;
        html += '		</td>' + EOL;
        html += '		<td class="left">' + EOL;
        html += '			<a onclick="$(\'#module-row' + module_row + '\').remove();" class="button"><?php echo $button_remove; ?></a>' + EOL;
        html += '		</td>' + EOL;
        html += '	</tr>' + EOL;
        html += '</tbody>' + EOL;

        $('#module tfoot').before(html);

        module_row++;
    }
//--></script> 
<?php echo $footer; ?>
