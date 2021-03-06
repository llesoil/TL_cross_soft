#!/bin/sh

numb='2355'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 2.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 25 --keyint 230 --lookahead-threads 1 --min-keyint 22 --qp 50 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.5,1.0,1.3,2.8,0.6,0.9,0.4,0,0,2,25,230,1,22,50,3,4,67,48,2,2000,1:1,umh,show,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"