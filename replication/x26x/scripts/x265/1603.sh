#!/bin/sh

numb='1604'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 2.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 15 --keyint 250 --lookahead-threads 1 --min-keyint 29 --qp 10 --qpstep 5 --qpmin 0 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.0,1.3,1.3,2.8,0.2,0.8,0.2,3,2,14,15,250,1,29,10,5,0,69,38,6,2000,-2:-2,umh,show,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"