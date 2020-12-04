#!/bin/sh

numb='977'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 25 --keyint 300 --lookahead-threads 0 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.4,1.4,2.2,0.4,0.7,0.9,3,2,4,25,300,0,25,20,4,1,64,38,4,1000,-2:-2,umh,show,slower,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"