#!/bin/sh

numb='1994'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 4.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 35 --keyint 270 --lookahead-threads 0 --min-keyint 30 --qp 20 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.3,1.4,4.0,0.3,0.8,0.9,2,1,0,35,270,0,30,20,4,0,68,38,1,1000,-2:-2,dia,show,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"