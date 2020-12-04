#!/bin/sh

numb='1897'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 15 --keyint 200 --lookahead-threads 2 --min-keyint 20 --qp 40 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset ultrafast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.0,1.0,1.3,1.6,0.5,0.9,0.4,3,1,12,15,200,2,20,40,5,3,62,48,2,1000,-2:-2,dia,show,ultrafast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"