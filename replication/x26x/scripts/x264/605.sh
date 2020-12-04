#!/bin/sh

numb='606'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 2.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 0 --keyint 210 --lookahead-threads 2 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.4,1.3,2.4,0.6,0.7,0.2,3,1,12,0,210,2,22,20,4,2,69,48,1,2000,1:1,hex,show,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"