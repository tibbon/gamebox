require 'helper'

describe "Using animation", acceptance: true do

  let!(:snelpling_idle_png) { mock_image('snelpling/idle/1.png') }
  let!(:snelpling_jump_1_png) { mock_image('snelpling/jump/1.png') }
  let!(:snelpling_jump_2_png) { mock_image('snelpling/jump/2.png') }
  let!(:snelpling_jump_3_png) { mock_image('snelpling/jump/3.png') }

  define_behavior :jump_on_j do
    requires :input_manager
    setup do
      input_manager.reg :down, KbJ do
        actor.action = :jump
      end
    end
  end
  define_actor_view :snelpling_view do
    draw do |target, x_off, y_off, z|
      actor.image.draw #offset_x, offset_y, z, x_scale, y_scale, color
    end
  end
  define_actor :snelpling do
    has_behavior :jump_on_j
    has_behavior :animated
  end

  it 'animates correctly' do
    game.stage do |stage|
      create_actor :snelpling
    end

    see_actor_attrs :snelpling, 
      action: :idle,
      image: snelpling_idle_png

    draw
    see_image_drawn snelpling_idle_png

    update 60
    draw
    see_image_drawn snelpling_idle_png

    press_key KbJ
    draw

    see_image_drawn snelpling_jump_1_png
    update 60
    draw

    see_image_drawn snelpling_jump_2_png
    update 60
    draw

    see_image_drawn snelpling_jump_3_png
    update 60
    draw

    see_image_drawn snelpling_jump_1_png

    pending "add callback checks?"
  end

end

