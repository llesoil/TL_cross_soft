#!/bin/sh

numb='1616'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 2.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 15 --keyint 230 --lookahead-threads 4 --min-keyint 26 --qp 30 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.6,1.4,2.8,0.5,0.6,0.9,2,0,6,15,230,4,26,30,4,2,69,38,5,2000,-2:-2,dia,crop,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"