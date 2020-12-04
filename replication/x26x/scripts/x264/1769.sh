#!/bin/sh

numb='1770'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 50 --keyint 270 --lookahead-threads 4 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.0,1.4,3.4,0.4,0.7,0.9,1,1,14,50,270,4,27,10,5,3,69,38,5,1000,-1:-1,umh,crop,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"