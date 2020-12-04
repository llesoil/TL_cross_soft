#!/bin/sh

numb='33'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 2.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 45 --keyint 300 --lookahead-threads 1 --min-keyint 21 --qp 30 --qpstep 5 --qpmin 4 --qpmax 69 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,3.0,1.3,1.3,2.0,0.5,0.9,0.9,2,0,4,45,300,1,21,30,5,4,69,38,4,1000,1:1,umh,show,faster,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"