#!/bin/sh

numb='428'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 4.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 5 --keyint 230 --lookahead-threads 2 --min-keyint 21 --qp 40 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.3,1.4,4.8,0.4,0.6,0.4,1,2,12,5,230,2,21,40,4,3,69,18,5,2000,1:1,umh,crop,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"