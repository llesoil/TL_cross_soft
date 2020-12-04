#!/bin/sh

numb='1576'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 20 --keyint 210 --lookahead-threads 4 --min-keyint 27 --qp 30 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.0,1.1,1.3,2.6,0.3,0.9,0.4,0,1,12,20,210,4,27,30,3,2,63,28,1,1000,1:1,hex,show,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"