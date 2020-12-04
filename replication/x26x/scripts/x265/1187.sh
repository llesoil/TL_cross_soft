#!/bin/sh

numb='1188'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 3.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 20 --keyint 210 --lookahead-threads 0 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.5,1.0,1.2,3.2,0.6,0.6,0.9,0,0,16,20,210,0,21,40,5,2,62,18,6,1000,1:1,umh,show,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"