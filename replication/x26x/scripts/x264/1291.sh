#!/bin/sh

numb='1292'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 15 --keyint 270 --lookahead-threads 1 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.6,1.0,4.4,0.4,0.8,0.2,3,1,14,15,270,1,30,50,4,3,66,28,6,2000,1:1,umh,show,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"