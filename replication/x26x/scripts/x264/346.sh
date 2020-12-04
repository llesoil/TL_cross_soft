#!/bin/sh

numb='347'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 0.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 40 --keyint 300 --lookahead-threads 1 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.0,1.4,0.2,0.2,0.6,0.0,3,1,2,40,300,1,27,40,5,4,68,48,2,2000,1:1,hex,show,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"