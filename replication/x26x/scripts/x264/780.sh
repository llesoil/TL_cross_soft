#!/bin/sh

numb='781'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 0.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 15 --keyint 280 --lookahead-threads 3 --min-keyint 23 --qp 30 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.5,1.1,1.3,0.2,0.3,0.9,0.6,1,0,6,15,280,3,23,30,5,4,63,28,3,2000,-2:-2,dia,crop,ultrafast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"