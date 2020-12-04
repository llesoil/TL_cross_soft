#!/bin/sh

numb='680'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 1.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 30 --keyint 210 --lookahead-threads 0 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,3.0,1.1,1.3,1.0,0.2,0.6,0.7,3,2,14,30,210,0,20,10,3,0,68,38,5,2000,-2:-2,umh,show,superfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"