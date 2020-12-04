#!/bin/sh

numb='2939'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 0.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 30 --keyint 290 --lookahead-threads 4 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.5,1.6,1.1,0.2,0.4,0.7,0.7,3,0,0,30,290,4,21,40,5,0,65,28,6,2000,-1:-1,hex,show,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"