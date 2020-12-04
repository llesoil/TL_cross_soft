#!/bin/sh

numb='1832'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 10 --keyint 280 --lookahead-threads 1 --min-keyint 26 --qp 0 --qpstep 5 --qpmin 1 --qpmax 62 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.3,1.0,2.2,0.6,0.7,0.6,1,2,14,10,280,1,26,0,5,1,62,18,4,2000,-1:-1,umh,show,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"