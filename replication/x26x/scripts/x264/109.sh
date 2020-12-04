#!/bin/sh

numb='110'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 35 --keyint 200 --lookahead-threads 4 --min-keyint 21 --qp 50 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.3,1.2,4.8,0.5,0.9,0.2,2,0,4,35,200,4,21,50,5,4,67,18,4,1000,-1:-1,dia,crop,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"