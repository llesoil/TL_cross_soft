#!/bin/sh

numb='2571'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 0 --keyint 270 --lookahead-threads 0 --min-keyint 26 --qp 20 --qpstep 5 --qpmin 0 --qpmax 60 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset veryslow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.1,1.2,0.8,0.5,0.6,0.1,0,2,10,0,270,0,26,20,5,0,60,38,6,2000,-2:-2,hex,crop,veryslow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"