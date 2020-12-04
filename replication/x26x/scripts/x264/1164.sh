#!/bin/sh

numb='1165'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 50 --keyint 270 --lookahead-threads 2 --min-keyint 26 --qp 10 --qpstep 3 --qpmin 1 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.4,1.1,4.0,0.2,0.7,0.7,2,1,16,50,270,2,26,10,3,1,65,18,5,2000,-1:-1,umh,show,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"