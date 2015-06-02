<?php
class ControllerModuleHomecards extends Controller {
    private $error = array(); 

    public function index() {   
        $this->load->language('module/homecards');

        $this->document->setTitle($this->language->get('heading_title'));

        $this->load->model('setting/setting');
        
        $token = 'token=' . $this->session->data['token'];

        if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
            $this->model_setting_setting->editSetting('homecards', $this->request->post);

            $this->session->data['success'] = $this->language->get('text_success');

            $this->redirect($this->url->link('extension/module', $token, 'SSL'));
        }

        $this->data['heading_title'] = $this->language->get('heading_title');

        $this->data['text_enabled'] = $this->language->get('text_enabled');
        $this->data['text_disabled'] = $this->language->get('text_disabled');
        $this->data['text_content_top'] = $this->language->get('text_content_top');
        $this->data['text_content_bottom'] = $this->language->get('text_content_bottom');
        $this->data['text_column_left'] = $this->language->get('text_column_left');
        $this->data['text_column_right'] = $this->language->get('text_column_right');
        $this->data['text_select_categories'] = $this->language->get('text_select_categories');
        $this->data['text_select_categories_description'] = $this->language->get('text_select_categories_description');
        
        $this->data['entry_layout'] = $this->language->get('entry_layout');
        $this->data['entry_position'] = $this->language->get('entry_position');
        $this->data['entry_status'] = $this->language->get('entry_status');
        $this->data['entry_sort_order'] = $this->language->get('entry_sort_order');
        $this->data['entry_main_image'] = $this->language->get('entry_main_image');
        $this->data['entry_child_image'] = $this->language->get('entry_child_image');
        $this->data['entry_category'] = $this->language->get('entry_category');
        
        $this->data['button_save'] = $this->language->get('button_save');
        $this->data['button_cancel'] = $this->language->get('button_cancel');
        $this->data['button_add_module'] = $this->language->get('button_add_module');
        $this->data['button_remove'] = $this->language->get('button_remove');
        
        $this->data['token'] = $this->session->data['token'];
        
        $this->data['positions'] = array(
            'content_top',
            'content_bottom',
            'column_left',
            'column_right',
        );

        if (isset($this->error['warning'])) {
            $this->data['error_warning'] = $this->error['warning'];
        } else {
            $this->data['error_warning'] = '';
        }
        
        $this->data['breadcrumbs'] = array();
        
        $this->data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/home', $token, 'SSL'),
            'separator' => false
        );
        
        $this->data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_module'),
            'href' => $this->url->link('extension/module', $token, 'SSL'),
            'separator' => ' :: '
        );
        
        $this->data['breadcrumbs'][] = array(
            'text' => $this->language->get('heading_title'),
            'href' => $this->url->link('module/homecards', $token, 'SSL'),
            'separator' => ' :: '
        );
        
        $this->data['action'] = $this->url->link('module/homecards', $token, 'SSL');
        
        $this->data['cancel'] = $this->url->link('extension/module', $token, 'SSL');
        
        $this->data['modules'] = array();
        
        if (isset($this->request->post['homecards_module'])) {
            $this->data['modules'] = $this->request->post['homecards_module'];
        } elseif ($this->config->get('homecards_module')) { 
            $this->data['modules'] = $this->config->get('homecards_module');
        }
        
        $this->data['homecards_categories'] = array();

        if (!is_null($categories = $this->config->get('homecards_categories'))) {
            $this->load->model('catalog/category');
            
            $result = array();
            
            foreach ($this->model_catalog_category->getCategories(array()) as $category) {
                $result[intval($category['category_id'])] = $category;
            }
            
            foreach ($categories as $category_id) {
                if (isset($result[intval($category_id)])) {
                    $this->data['homecards_categories'][] = $result[intval($category_id)];
                }
            }
        }
        
        $this->load->model('design/layout');
        
        $this->data['layouts'] = $this->model_design_layout->getLayouts();
        
        $this->template = 'module/homecards.tpl';
        
        $this->children = array(
            'common/header',
            'common/footer'
        );
        
        $this->response->setOutput($this->render());
    }

    private function validate() {
        if (!$this->user->hasPermission('modify', 'module/homecards')) {
            $this->error['warning'] = $this->language->get('error_permission');
        }
        
        if (!$this->error) {
            return true;
        }
        
        return false;
    }
}
