#!/bin/sh

numb='1921'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 0.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 45 --keyint 240 --lookahead-threads 4 --min-keyint 30 --qp 10 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.3,1.4,0.4,0.4,0.9,0.5,1,2,8,45,240,4,30,10,5,0,62,28,6,1000,-2:-2,hex,show,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"