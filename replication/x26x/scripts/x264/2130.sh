#!/bin/sh

numb='2131'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 20 --keyint 250 --lookahead-threads 0 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.3,1.0,4.2,0.4,0.6,0.9,3,2,2,20,250,0,27,0,3,3,69,28,4,1000,1:1,hex,crop,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"