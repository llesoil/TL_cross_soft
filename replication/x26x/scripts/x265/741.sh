#!/bin/sh

numb='742'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 1.0 --qblur 0.6 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 25 --keyint 230 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,3.0,1.0,1.1,1.0,0.6,0.8,0.5,2,2,2,25,230,2,30,40,4,0,66,38,4,1000,-2:-2,hex,show,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"